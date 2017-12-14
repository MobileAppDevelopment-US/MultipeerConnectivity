//
//  Models.h
//  MultipeerConnectivity
//
//  Created by User on 06.10.17.
//  Copyright © 2017 Serik_Klement. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DrawingPoint : NSObject <NSCoding>

@property (assign, nonatomic) BOOL isFirst;
@property (assign, nonatomic) CGPoint point;

@end
