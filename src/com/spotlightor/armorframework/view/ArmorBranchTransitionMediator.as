package com.spotlightor.armorframework.view 
{
	import com.spotlightor.armorframework.constants.ArmorNotifications;
	import com.spotlightor.armorframework.interfaces.IPage;
	import com.spotlightor.armorframework.model.vo.PageNode;
	import com.spotlightor.events.TransitionEvent;
	import com.spotlightor.utils.Log;
	import flash.events.EventDispatcher;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	/**
	 * ...
	 * @author 高鸣 - 交典创艺 (Spotlightor.com)
	 */
	public class ArmorBranchTransitionMediator extends Mediator 
	{
		public static const NAME:String = "mediator_ArmorBranchTransitionMediator";
		
		private static const STATE_REST					:int = 0;
		private static const STATE_TRANSITION			:int = 1;
		private static const STATE_PRELOAD				:int = 2;
		
		private var _state:int = STATE_REST;
		
		private var _numPageNodesToTransitionOut:int;
		private var _queuedBranchNodes:Vector.<PageNode>;
		private var _pageInTransition:IPage;
		// 2011.3.4
		private var _pageNodeInTransition:PageNode;
		
		public function ArmorBranchTransitionMediator() 
		{ 
			super(NAME, null);
		} 
		
		override public function listNotificationInterests():Array 
		{
			return [ArmorNotifications.GOTO_INTERNAL, ArmorNotifications.PRELOAD_BRANCH_COMPLETE];
		}
		
		override public function handleNotification(notification:INotification):void 
		{
			switch(notification.getName())
			{
				case ArmorNotifications.GOTO_INTERNAL: {
					var branchNodes:Vector.<PageNode> = notification.getBody() as Vector.<PageNode>;
					if (branchNodes) tryGotoInternal(branchNodes);
					else Log.warning(this, "GOTO_INTERNAL notification's body contains no branchNodes!");
					break;
				}
				case ArmorNotifications.PRELOAD_BRANCH_COMPLETE: {
					transitionInQueuedBranch();
					break;
				}
			}
		}
		
		private function tryGotoInternal(branchNodes:Vector.<PageNode>):void
		{
			if (currentBranchNodes)
			{
				var minLength:int = Math.min(branchNodes.length, currentBranchNodes.length);
				for (var i:int = 0; i < minLength; i++) 
				{
					if (branchNodes[i] != currentBranchNodes[i]) break;
				}
				if (i < branchNodes.length) _queuedBranchNodes = branchNodes.slice(i, branchNodes.length);
				else _queuedBranchNodes = null;
				_numPageNodesToTransitionOut = currentBranchNodes.length - i;
				
				if (_numPageNodesToTransitionOut == 0 && _queuedBranchNodes == null)
				{
					// the same as current branch
					Log.info(this, "Target branch is the same as current branch, stop transition.");
					return;
				}
			}
			else
			{
				_queuedBranchNodes = branchNodes;
				_numPageNodesToTransitionOut = 0;
			}
			if (state == STATE_TRANSITION)
			{
				Log.status(this, "Branch in transition, wait for", _pageInTransition, "transition complete and restart goto.");
				// transition还在进行中，中断连续transition逻辑，等当前的transition结束
				if (_pageInTransition) {
					_pageInTransition.removeEventListener(TransitionEvent.IN_COMPLETE, transitionInFirstQueuedPageNodeOrComplete);
					_pageInTransition.removeEventListener(TransitionEvent.OUT_COMPLETE, transitionOutLastPageNodeOrComplete);
					_pageInTransition.addEventListener(TransitionEvent.IN_COMPLETE, onTransitionCompleteGotoBranch);
					_pageInTransition.addEventListener(TransitionEvent.OUT_COMPLETE, onTransitionCompleteGotoBranch);
				}
				else Log.error(this, "Branch in transition, but where is the _pageInTransition?");
			}
			else 
			{
				// preloading进行中
				if (state == STATE_PRELOAD) sendNotification(ArmorNotifications.CANCEL_PRELOAD_BRANCH);
				gotoBranch();
			}
		}
		
		/**
		 * 如果在goto的时候，正在进行branch transition（不论in或是out），监听当前pageInTransition的complete事件，然后执行gotoBranch的逻辑
		 * @param	e
		 */
		private function onTransitionCompleteGotoBranch(e:TransitionEvent):void 
		{
			if (_pageInTransition)
			{
				_pageInTransition.removeEventListener(TransitionEvent.IN_COMPLETE, onTransitionCompleteGotoBranch);
				_pageInTransition.removeEventListener(TransitionEvent.OUT_COMPLETE, onTransitionCompleteGotoBranch);
				_pageInTransition = null;
				_pageNodeInTransition = null;
			}
			Log.status(this, "Restart goto");
			gotoBranch();
		}
		
		/**
		 * 开始实施branch transition的整个流程
		 */
		private function gotoBranch():void
		{
			//TODO 按照Flow来决定transition in/out/preload的顺序
			// 目前是transition out --> preload --> transition in
			Log.status(this, "Start branch transition");
			transitionOutCurrentBranch();
		}
		
		/**
		 * transition out当前的branch
		 */
		private function transitionOutCurrentBranch():void
		{
			state = STATE_TRANSITION;
			var outNodes:Vector.<PageNode>;
			if (currentBranchNodes) outNodes = currentBranchNodes.slice(currentBranchNodes.length - _numPageNodesToTransitionOut, currentBranchNodes.length);
			sendNotification(ArmorNotifications.TRANSITION_OUT_BRANCH, outNodes);
			Log.status(this, "Transition out branch.");
			
			transitionOutLastPageNodeOrComplete();
		}
		
		private function transitionOutLastPageNodeOrComplete(e:TransitionEvent = null):void
		{
			if (e) {
				(e.target as EventDispatcher).removeEventListener(TransitionEvent.OUT_COMPLETE, transitionOutLastPageNodeOrComplete);
				Log.status(this, "Page transition out complete:", e.target);
				
				if (_pageNodeInTransition.unload) sendNotification(ArmorNotifications.UNLOAD_PAGE, _pageNodeInTransition.id);
			}
			
			if (_numPageNodesToTransitionOut > 0)
			{
				_pageNodeInTransition = currentBranchNodes.pop();
				_pageInTransition = _pageNodeInTransition.content as IPage;
				_pageInTransition.addEventListener(TransitionEvent.OUT_COMPLETE, transitionOutLastPageNodeOrComplete);
				_pageInTransition.transitionOut();
				_numPageNodesToTransitionOut--;
				Log.status(this, "transition out page:", _pageInTransition);
			}
			else
			{
				_pageInTransition = null;
				_pageNodeInTransition = null;
				sendNotification(ArmorNotifications.TRANSITION_OUT_BRANCH_COMPLETE);
				Log.status(this, "transition out branch complete");
				preloadQueuedBranch();
			}
		}
		
		/**
		 * 预载入需要载入的queued branch
		 */
		private function preloadQueuedBranch():void
		{
			state = STATE_PRELOAD;
			if (_queuedBranchNodes && _queuedBranchNodes.length > 0)
			{
				sendNotification(ArmorNotifications.PRELOAD_BRANCH, _queuedBranchNodes);
				Log.status(this, "start preload queued branch");
			}
			else 
			{
				Log.status(this, "The queued branch is empty, just transition in the queued.");
				transitionInQueuedBranch();
			}
		}
		
		/**
		 * transition in目标branch nodes
		 */
		private function transitionInQueuedBranch():void
		{
			state = STATE_TRANSITION;
			sendNotification(ArmorNotifications.TRANSITION_IN_BRANCH, _queuedBranchNodes);
			Log.status(this, "Transition in branch");
			
			transitionInFirstQueuedPageNodeOrComplete();
		}
		
		private function transitionInFirstQueuedPageNodeOrComplete(e:TransitionEvent = null):void
		{
			if (e) 
			{
				var pageTransitionInComplete:IPage = e.target as IPage;
				(pageTransitionInComplete as EventDispatcher).removeEventListener(TransitionEvent.IN_COMPLETE, transitionInFirstQueuedPageNodeOrComplete);
				Log.status(this, "transition in page complete", pageTransitionInComplete);
			}
			
			if (_queuedBranchNodes && _queuedBranchNodes.length > 0) 
			{
				var pageNode:PageNode = _queuedBranchNodes.shift();
				_pageNodeInTransition = pageNode;
				_pageInTransition = pageNode.content as IPage;
				if (!currentBranchNodes) viewComponent = new Vector.<PageNode>();
				currentBranchNodes.push(pageNode);
				_pageInTransition.addEventListener(TransitionEvent.IN_COMPLETE, transitionInFirstQueuedPageNodeOrComplete);
				_pageInTransition.transitionIn();
				Log.status(this, "transition in page:", _pageInTransition);
			}
			else
			{
				_pageInTransition = null;
				_pageNodeInTransition = null;
				state = STATE_REST;
				sendNotification(ArmorNotifications.TRANSITION_IN_BRANCH_COMPLETE, currentBranchNodes);
				Log.status(this, "transition in branch complete");
			}
		}
		
		protected function get currentBranchNodes():Vector.<PageNode> { return viewComponent as Vector.<PageNode>; }
		
		public function get state():int { return _state; }
		
		public function set state(value:int):void 
		{
			if (value != _state)
			{
				switch(_state)// leave old state, do sth
				{
					case STATE_REST: {
						break;
					}
					case STATE_TRANSITION: {
						break;
					}
					case STATE_PRELOAD: {
						break;
					}
				}
				switch(value)// enter new state, do sth
				{
					case STATE_REST: {
						break;
					}
					case STATE_TRANSITION: {
						break;
					}
					case STATE_PRELOAD: {
						break;
					}
				}
			}
			_state = value;
		}
	}
	
}