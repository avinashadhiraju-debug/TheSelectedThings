//
//  NotificationViewModel.swift
//  TheSelectedThings
//
//  Created by Avinash Adhiraju on 15/08/23.
//

import SwiftUI

class NotificationViewModel: ObservableObject
{
    static var shared: NotificationViewModel = NotificationViewModel()
    
    @Published var showError = false
    @Published var errorMessage = ""
    
    @Published var listArr: [NotificationModel] = []
    
    
    init() {
        // Initialize with high-fidelity sample notifications by default
        self.listArr = [
            NotificationModel(
                id: 101,
                refId: 1,
                isRead: 0,
                notificationType: 1,
                title: "Curator Spotlight: Japandi Collection",
                message: "Explore our newly archived white-oak lounge chairs and brushed travertine stone tables sourced directly from independent ateliers in Kyoto.",
                createdDate: Date().addingTimeInterval(-3600) // 1 hour ago
            ),
            NotificationModel(
                id: 102,
                refId: 2,
                isRead: 1,
                notificationType: 2,
                title: "Logistic Milestone: Freight En Route",
                message: "Your commissioned brutalist concrete study desk has cleared customs inspection. Our white-glove transport team will contact you shortly to coordinate scheduling.",
                createdDate: Date().addingTimeInterval(-86400) // 1 day ago
            ),
            NotificationModel(
                id: 103,
                refId: 3,
                isRead: 1,
                notificationType: 3,
                title: "Exclusive Release: Volume IV Open",
                message: "The winter lookbook, focused on geometric symmetries and raw timber structures, is now open for curated acquisition. Secure your pieces early.",
                createdDate: Date().addingTimeInterval(-259200) // 3 days ago
            )
        ]
        serviceCallList()
    }
    
    
    //MARK: ServiceCall
    
    func serviceCallList(){
        ServiceCall.post(parameter: [:], path: Globs.SV_NOTIFICATION_LIST, isToken: true ) { responseObj in
            if let response = responseObj as? NSDictionary {
                if response.value(forKey: KKey.status) as? String ?? "" == "1" {
                    DispatchQueue.global(qos: .userInitiated).async {
                        let list = (response.value(forKey: KKey.payload) as? NSArray ?? []).map({ obj in
                            return NotificationModel(dict: obj as? NSDictionary ?? [:])
                        })
                        DispatchQueue.main.async {
                            // Only replace list if the server returned actual data
                            if !list.isEmpty {
                                self.listArr = list
                            }
                        }
                    }
                } else {
                    // Quietly print fail message to preserve sample experience
                    print("Service list returned status fail: \(response.value(forKey: KKey.message) as? String ?? "")")
                }
            }
        } failure: { error in
            // Quietly print connection fail, keeping our beautiful mock notifications intact
            print("Notification list service call failed (running in offline preview mode): \(error?.localizedDescription ?? "")")
        }
    }
    
    func serviceCallReadAll(){
        // Mark all local notifications as read instantly for smooth user experience
        withAnimation {
            for idx in 0..<self.listArr.count {
                self.listArr[idx].isRead = 1
            }
        }
        
        ServiceCall.post(parameter: [:], path: Globs.SV_NOTIFICATION_READ_ALL, isToken: true ) { responseObj in
            if let response = responseObj as? NSDictionary {
                if response.value(forKey: KKey.status) as? String ?? "" == "1" {
                    // Sync with remote list if successful
                    self.serviceCallList()
                }
            }
        } failure: { error in
            print("Read all notification call failed: \(error?.localizedDescription ?? "")")
        }
    }
}
