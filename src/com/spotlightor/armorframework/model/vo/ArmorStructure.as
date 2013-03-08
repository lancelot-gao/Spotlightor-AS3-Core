package com.spotlightor.armorframework.model.vo 
{
	import com.spotlightor.utils.Log;
	import com.spotlightor.utils.StringParser;
	/**
	 * ...
	 * @author 高鸣 - 交典创艺 (Spotlightor.com)
	 */
	public class ArmorStructure
	{
		private var _indexPageNode	:PageNode;
		private var _appTitle		:String;
		//private var _assets
		
		public function ArmorStructure(appXML:XML) 
		{
			_indexPageNode = new PageNode(appXML.app.page[0], null);
			_appTitle = StringParser.stringValue(appXML.app.@title, "Nameless Site:%PAGE%");
		}
		
		public function get firstBranchNodes():Vector.<PageNode>
		{
			var branchNodes:Vector.<PageNode> = new Vector.<PageNode>();
			var currentPageNode:PageNode = _indexPageNode;
			branchNodes.push(currentPageNode);
			while (currentPageNode.childNodes != null && currentPageNode.childNodes.length > 0)
			{
				currentPageNode = currentPageNode.childNodes[0];
				branchNodes.push(currentPageNode);
			}
			return branchNodes;
		}
		
		/**
		 * 通过branch string（例如index/works/interaction)获取page nodes（由root开始依次向后）
		 * @param	branch
		 * @return
		 */
		public function getBranchNodes(branch:String):Vector.<PageNode>
		{
			var pageIDs:Array = branch.split('/');
			if (pageIDs)
			{
				var branchNodes:Vector.<PageNode> = new Vector.<PageNode>();
				var currentPageNode:PageNode = _indexPageNode;
				if (pageIDs[0] == currentPageNode.id) branchNodes.push(currentPageNode);
				else {
					Log.error(this, "The root of branch's id is not", _indexPageNode.id);
					return null;
				}
				for (var i:int = 1; i < pageIDs.length; i++) 
				{
					currentPageNode = currentPageNode.childNodesDict[pageIDs[i]];
					if (currentPageNode != null) branchNodes.push(currentPageNode);
					else {
						Log.error(this, "Cannot find page node with id", pageIDs[i]);
						return null;
					}
				}
				return branchNodes;
			}
			return null;
		}
		
		/**
		 * 通过pageID获得它所在Branch的所有Page Nodes
		 * @param	pageID
		 * @return
		 */
		public function getBranchNodesByPageID(pageID:String):Vector.<PageNode>
		{
			var pageNode:PageNode = getPageNodeByID(pageID);
			if (pageNode)
			{
				var branchNodes:Vector.<PageNode> = new Vector.<PageNode>();
				branchNodes.push(pageNode);
				while (pageNode.parentNode)
				{
					branchNodes.push(pageNode.parentNode);
					pageNode = pageNode.parentNode;
				}
				branchNodes = branchNodes.reverse();
				return branchNodes;
			}
			else return null;
		}
		
		/**
		 * 通过pageID获得它所对应的PageNode
		 * @param	pageID
		 * @return
		 */
		public function getPageNodeByID(pageID:String):PageNode
		{
			if (pageID != null && pageID != "")
			{
				if (_indexPageNode.id == pageID) return _indexPageNode;
				else return getPageNodeInChildren(_indexPageNode, pageID);
			}
			else return null;
		}
		
		public function getPageAssetByID(assetID:String):PageAsset
		{
			if (assetID != null && assetID != "")
			{
				return getPageAssetInChildren(_indexPageNode, assetID);
			}
			return null;
		}
		
		private function getPageAssetInChildren(parentNode:PageNode, targetID:String):PageAsset
		{
			if (parentNode.assetsDict)
			{
				if (parentNode.assetsDict[targetID]) return parentNode.assetsDict[targetID];
			}
			if (parentNode.childNodesDict)
			{
				for each (var childNode:PageNode in parentNode.childNodes) {
					var result:PageAsset = getPageAssetInChildren(childNode, targetID);
					if (result != null) return result;
				}
			}
			return null;
		}
		
		private function getPageNodeInChildren(parentNode:PageNode, targetID:String):PageNode
		{
			if (parentNode && parentNode.childNodesDict)
			{
				if (parentNode.childNodesDict[targetID]) return parentNode.childNodesDict[targetID];
				else 
				{
					for each (var childNode:PageNode in parentNode.childNodes) {
						var result:PageNode = getPageNodeInChildren(childNode, targetID);
						if (result != null) return result;
					}
				}
			}
			return null;
		}
		
		public function get indexPageNode():PageNode { return _indexPageNode; }
		
		public function get appTitle():String { return _appTitle; }
		
	}

}