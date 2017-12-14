//
//  Models.m
//  MultipeerConnectivity
//
//  Created by User on 06.10.17.
//  Copyright © 2017 Serik_Klement. All rights reserved.
//

#import "DrawingPoint.h"
#import "DrawingView.h"

@implementation DrawingPoint

#pragma mark NSCoding

- (nullable instancetype)initWithCoder:(nonnull NSCoder *)aDecoder {

    self = [super init];
    if (self) {
        self.isFirst = [aDecoder decodeBoolForKey:@"isFirst"];
        self.point = [aDecoder decodeCGPointForKey:@"point"];
    }
    return self;
}

- (void)encodeWithCoder:(nonnull NSCoder *)aCoder {
    
    [aCoder encodeBool:self.isFirst forKey:@"isFirst"];
    [aCoder encodeCGPoint:self.point forKey:@"point"];
}

@end


