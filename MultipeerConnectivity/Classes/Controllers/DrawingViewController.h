//
//  DrawingViewController.h
//  MultipeerConnectivity
//
//  Created by User on 03.10.17.
//  Copyright © 2017 Serik_Klement. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MultipeerViewController.h"
#import "DeviceNetworkConnection.h"

@interface DrawingViewController : UIViewController

@property (nonatomic, weak) MultipeerViewController *multipeerController;
@property (nonatomic, strong) DeviceNetworkConnection *networkConnection;

@end
