//
//  MCManager.h
//  MultipeerConnectivity
//
//  Created by User on 09.10.17.
//  Copyright © 2017 Serik_Klement. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>
#import "DrawingPoint.h"

extern NSString *const kServiceType;

@protocol DeviceNetworkConnectionDelegate;

@interface DeviceNetworkConnection : NSObject <MCSessionDelegate, NSStreamDelegate, MCBrowserViewControllerDelegate>

@property (nonatomic, strong) MCBrowserViewController *browser;
@property (nonatomic, weak) id<DeviceNetworkConnectionDelegate> delegate;

- (void)startAdvertising;
- (void) isStarting;
- (void) isStopping;
- (void) sendMessage:(NSString*) message;
- (void) sendPoint:(DrawingPoint*)modelPoint;

@end

@protocol DeviceNetworkConnectionDelegate <NSObject>

@optional
-(void)recievedDrawingPoint:(DrawingPoint*) drawingPoint;
-(void)recievedMessage:(NSString*) message;

@end





