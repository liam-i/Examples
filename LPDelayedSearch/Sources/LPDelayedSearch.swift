//
//  LPDelayedSearch.swift
//  LPDelayedSearch <https://github.com/leo-lp/LPDelayedSearch>
//
//  Created by pengli on 2018/5/22.
//  Copyright © 2018年 pengli. All rights reserved.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

import UIKit

public typealias LPPerformSearchBlock = (_ text: String?) -> Void
public protocol LPDelayedSearch: class {
    
    /// 获取搜索视图
    var searchView: UIView { get }
    
    /// 延迟搜索：支持UISearchBar、UITextField 和 UITextView
    ///
    /// - Parameters:
    ///   - delay: 延长时间
    ///   - execute: 执行搜索代码块
    func performSearch(afterDelay delay: TimeInterval,
                       execute: @escaping LPPerformSearchBlock)
    
    /// 执行搜索
    ///
    /// - Returns: 搜索文本
    func performSearchNow() -> String?
}

public extension LPDelayedSearch {
    
    func performSearch(afterDelay delay: TimeInterval,
                       execute: @escaping LPPerformSearchBlock) {
        let view = searchView
        let observer = LPDelayedSearchInternal.observer(of: view)
        guard observer == nil else { return }
        LPDelayedSearchInternal(toSearchView: view,
                                afterDelay: delay,
                                searchBlock: execute)
    }
    
    func performSearchNow() -> String? {
        let view = searchView
        guard let observer = LPDelayedSearchInternal.observer(of: view) else {
            return view.value(forKeyPath: "text") as? String
        }
        return observer.performSearchNow()
    }
}

extension UISearchBar: LPDelayedSearch {
    public var searchView: UIView { return self }
}

extension UITextField: LPDelayedSearch {
    public var searchView: UIView { return self }
}

extension UITextView: LPDelayedSearch {
    public var searchView: UIView { return self }
}


// MARK: -
// MARK: - LPDelayedSearch Class

private var LPDelayedSearchKey: Void?
private class LPDelayedSearchInternal {
    private var delayTime: TimeInterval = 0.8
    private var performSearchBlock: ((_ text: String?) -> Void)?
    
    private weak var searchView: UIView?
    private var performDispatchWork: DispatchWorkItem?
    private var textOfHistory: String?
    
    deinit {
        cancelPerformDispatchWork()
        NotificationCenter.default.removeObserver(self)
        
        #if DEBUG
        print("LPDelayedSearch: -> release memory.")
        #endif
    }
    
    static func observer(of searchView: UIView) -> LPDelayedSearchInternal? {
        let objc = objc_getAssociatedObject(searchView, &LPDelayedSearchKey)
        return objc as? LPDelayedSearchInternal
    }
    
    @discardableResult
    init(toSearchView view: UIView,
         afterDelay delay: TimeInterval,
         searchBlock: @escaping LPPerformSearchBlock) {
        searchView = view
        delayTime = delay
        performSearchBlock = searchBlock
        
        objc_setAssociatedObject(view,
                                 &LPDelayedSearchKey,
                                 self,
                                 .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        
        let center = NotificationCenter.default
        center.addObserver(self,
                           selector: #selector(textDidChange),
                           name: .UITextFieldTextDidChange,
                           object: nil)
        center.addObserver(self,
                           selector: #selector(textDidChange),
                           name: .UITextViewTextDidChange,
                           object: nil)
    }
    
    func performSearchNow() -> String? {
        cancelPerformDispatchWork()
        return searchView?.value(forKeyPath: "text") as? String
    }
    
    private func callPerformDispatchWork() {
        /// 取消上一次的延迟任务
        cancelPerformDispatchWork()
        
        /// 设置新的延迟时间
        let performWork = DispatchWorkItem { [weak self] in
            guard let `self` = self else { return }
            self.performSearchBlock?(self.textOfHistory)
        }
        DispatchQueue.main.asyncAfter(wallDeadline: .now() + delayTime, execute: performWork)
        performDispatchWork = performWork
    }
    
    /// 取消延迟任务
    private func cancelPerformDispatchWork() {
        guard let performWork = performDispatchWork else { return }
        performWork.cancel()
        performDispatchWork = nil
    }
    
    @objc private func textDidChange(_ notify: Notification) {
        guard let searchView = findSearchView(for: notify.object) else { return }
        
        let text = searchView.value(forKeyPath: "text") as? String
        guard text != textOfHistory else { return }
        
        textOfHistory = text
        
        callPerformDispatchWork()
    }
    
    private func findSearchView(for object: Any?) -> UIView? {
        guard let searchView = searchView
            , let subView = object as? UIView else { return nil }
        let rootTypeName = "\(type(of: searchView))"
        
        var viewPointer: UIView? = subView
        while let tmpView = viewPointer {
            let tmpTypeName = "\(type(of: tmpView))"
            
            //print("\(rootTypeName, tmpTypeName)")
            
            /// 找到SearchView的RootView
            if rootTypeName == tmpTypeName {
                /// 判断RootView是否当前正在输入的SearchView
                return tmpView == searchView ? tmpView : nil
            } else if tmpView is LPDelayedSearch
                && tmpTypeName != "UISearchBarTextField" {
                return nil
            } else if tmpView.next is UIViewController {
                return nil
            }
            viewPointer = tmpView.superview
        }
        return nil
    }
}
