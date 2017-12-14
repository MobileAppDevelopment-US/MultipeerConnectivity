//
//  DravingView.h
//  MultipeerConnectivity
//
//  Created by User on 03.10.17.
//  Copyright © 2017 Serik_Klement. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DrawingPoint.h"

@protocol DrawingViewDelegate;

@interface DrawingView : UIView

@property (weak, nonatomic) id <DrawingViewDelegate> delegate;

@end

@protocol DrawingViewDelegate <NSObject>

- (void)didUpdatedPoint:(DrawingPoint *)modelPoint;

@end





