//
//  DrawingViewController.m
//  MultipeerConnectivity
//
//  Created by User on 03.10.17.
//  Copyright © 2017 Serik_Klement. All rights reserved.
//

#import "DrawingViewController.h"
#import "DrawingView.h"
#import "ShowView.h"

@interface DrawingViewController ()<DrawingViewDelegate, DeviceNetworkConnectionDelegate>

@property (weak, nonatomic) IBOutlet DrawingView *drawingView;
@property (weak, nonatomic) IBOutlet ShowView *showView;

@end

@implementation DrawingViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.drawingView.delegate = self;
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.networkConnection.delegate = self;
}

#pragma mark - DrawingViewDelegate

- (void) didUpdatedPoint:(DrawingPoint*)modelPoint {

    [self.networkConnection sendPoint:modelPoint];
}

#pragma mark - DeviceNetworkConnectionDelegate

- (void) recievedDrawingPoint:(DrawingPoint*) modelPoint {
    
    [self.showView recievedDrawingPoint:modelPoint];
}

@end
