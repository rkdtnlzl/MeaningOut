//
//  CoreDataManager.swift
//  MeaningOut
//
//  Created by 강석호 on 6/15/24.
//

import Foundation
import UIKit
import CoreData

enum CoreDataName: String {
    case recentResearch = "RecentResearchTerm"
}

class CoreDataManager {
    static let shared: CoreDataManager = CoreDataManager()
    
    private let appDelegate = UIApplication.shared.delegate as? AppDelegate
    private lazy var context = appDelegate?.persistentContainer.viewContext
    
}
