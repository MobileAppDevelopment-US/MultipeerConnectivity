//
//  ViewController.h
//  MultipeerConnectivity
//
//  Created by User on 02.10.17.
//  Copyright © 2017 Serik_Klement. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeviceNetworkConnection.h"

@interface MultipeerViewController : UIViewController

@property (nonatomic, strong) DeviceNetworkConnection *networkConnection;

- (void) dismissKeyboard;
- (void) configureElements;
- (void) sendMessageToLabel;

@end

