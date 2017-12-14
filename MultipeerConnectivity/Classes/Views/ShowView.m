//
//  ShowView.m
//  MultipeerConnectivity
//
//  Created by User on 04.10.17.
//  Copyright © 2017 Serik_Klement. All rights reserved.
//

#import "ShowView.h"

@implementation ShowView  {
    
UIBezierPath *path;

}

#pragma mark - Lifecycle

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    if (self = [super initWithCoder:aDecoder]) {
        [self setMultipleTouchEnabled:false];
        [self setBackgroundColor:[UIColor whiteColor]];
        path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(0, 0)];
        [path setLineWidth:2.0];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    
    [[UIColor blackColor] setStroke];
    [path stroke];
    
}

- (void) recievedDrawingPoint:(DrawingPoint*) modelPoint {

    if (modelPoint.isFirst) { // если только коснулся задаю начало линии
        [path moveToPoint:modelPoint.point];
    } else { // если продолжаю касание рисую линию
        [path addLineToPoint:modelPoint.point];
    }
    [self setNeedsDisplay];
}

@end
