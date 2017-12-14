//
//  ShowView.h
//  MultipeerConnectivity
//
//  Created by User on 04.10.17.
//  Copyright © 2017 Serik_Klement. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DrawingView.h"
#import "DeviceNetworkConnection.h"

@interface ShowView : UIView

- (void) recievedDrawingPoint:(DrawingPoint*) modelPoint;

@end
