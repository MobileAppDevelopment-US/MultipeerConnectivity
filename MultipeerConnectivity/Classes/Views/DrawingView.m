//
//  DravingView.m
//  MultipeerConnectivity
//
//  Created by User on 03.10.17.
//  Copyright © 2017 Serik_Klement. All rights reserved.
//

#import "DrawingView.h"

@implementation DrawingView {
    
    UIBezierPath *path;
}

#pragma mark - Lifecycle

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    if (self = [super initWithCoder:aDecoder]) {
        [self setMultipleTouchEnabled:NO];
        [self setBackgroundColor:[UIColor whiteColor]];
        path = [UIBezierPath bezierPath];
        [path setLineWidth:2.0];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    
    [[UIColor blackColor] setStroke];
    [path stroke];
}

#pragma mark - Touches

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    [path moveToPoint:point];
    
    DrawingPoint *modelPoint = [[DrawingPoint alloc] init];
    modelPoint.point = point;
    modelPoint.isFirst = true;
    [self.delegate didUpdatedPoint:modelPoint];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    [path addLineToPoint:point]; // передавать в 2 вью
    
    //передаю модель в поток
    DrawingPoint *modelPoint = [[DrawingPoint alloc] init];
    modelPoint.point = point;
    modelPoint.isFirst = false;
    
    [self.delegate didUpdatedPoint:modelPoint];
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self touchesMoved:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self touchesEnded:touches withEvent:event];
}

@end
