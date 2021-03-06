//  Copyright © 2018 ObjectBox. All rights reserved.

import UIKit
import ObjectBox

extension Store {
    /// Creates a new ObjectBox.Store in a temporary directory.
    static func createStore() throws -> Store {
        let directory = try FileManager.default.url(
            for: .applicationSupportDirectory,
            in: FileManager.SearchPathDomainMask.userDomainMask,
            appropriateFor: nil,
            create: true)
        return try Store(directoryPath: directory.path)
    }
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        try! setupDemoNotes()
        setupSplitViewController()
        
        return true
    }

    private func setupDemoNotes() throws {
        let noteBox = Services.instance.noteBox
        let authorBox = Services.instance.authorBox

        guard noteBox.isEmpty && authorBox.isEmpty else { return }

        try Services.instance.replaceWithDemoData()
    }

    private var splitViewController: UISplitViewController { return window!.rootViewController as! UISplitViewController }

    private func setupSplitViewController() {
        let navigationController = splitViewController.viewControllers[splitViewController.viewControllers.count-1] as! UINavigationController
        navigationController.topViewController!.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem
        splitViewController.delegate = self
    }

}

// MARK: - Split view

extension AppDelegate {

    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        guard let secondaryAsNavController = secondaryViewController as? UINavigationController else { return false }

        // Collapse onto placeholder (on launch)
        if secondaryAsNavController.restorationIdentifier == "PlaceholderNavController" {
            return true
        }

        guard let topAsNoteController = secondaryAsNavController.topViewController as? NoteEditingViewController else { return false }
        if topAsNoteController.note == nil {
            // Return true to indicate that we have handled the collapse by doing nothing; the secondary controller will be discarded.
            return true
        }
        return false
    }

}
