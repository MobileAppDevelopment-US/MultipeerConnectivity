//
//  ViewController.m
//  MultipeerConnectivity
//
//  Created by User on 02.10.17.
//  Copyright © 2017 Serik_Klement. All rights reserved.
//

#import "MultipeerViewController.h"
#import "DrawingViewController.h"

@interface MultipeerViewController () <DeviceNetworkConnectionDelegate>

@property (nonatomic,weak) IBOutlet UITextField *sendMessageField;
@property (nonatomic,weak) IBOutlet UILabel *recievedMessageLabel;
@property (nonatomic,weak) IBOutlet UILabel *startAdvertisingLabel;
@property (nonatomic,weak) IBOutlet UISwitch *startAdvertisingSwitch;

@end

@implementation MultipeerViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
     
    [self configureElements];
    self.networkConnection = [[DeviceNetworkConnection alloc] init];
    [self.networkConnection startAdvertising];

    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]
                                           initWithTarget:self
                                           action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tapGesture];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.networkConnection.delegate = self;
}

#pragma mark - Actions

- (IBAction)advertisingValueChanged:(id)sender {
    
        if ([sender isOn]) {
            [self.networkConnection isStarting];
        } else {
            [self.networkConnection isStopping];
        }
}

- (IBAction)browserButtonClicked:(id)sender {
    
    [self presentViewController:self.networkConnection.browser animated: true completion:nil];
}

- (IBAction)sendButtonAction:(id)sender {
 
    self.recievedMessageLabel.text = @"";
    [self sendMessageToLabel];
    self.sendMessageField.text = @"";
}

- (IBAction)openDrawingVCAction:(id)sender {
 
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"DrawingViewController" bundle:nil];
    DrawingViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"DrawingViewController"];
    controller.multipeerController = self; // передаю себя в DrawingViewController
    controller.networkConnection = self.networkConnection;
    [self.navigationController pushViewController:controller animated:true];
}

#pragma mark - Methods

- (void) dismissKeyboard {
    
    [self.view endEditing:true];
}

- (void) configureElements {
    
    self.sendMessageField.layer.borderWidth = 1;
    self.sendMessageField.layer.borderColor = [UIColor blackColor].CGColor;
    self.recievedMessageLabel.layer.borderWidth = 1;
    self.recievedMessageLabel.layer.borderColor = [UIColor blackColor].CGColor;
    self.startAdvertisingLabel.layer.borderWidth = 1;
    self.startAdvertisingLabel.layer.borderColor = [UIColor blackColor].CGColor;
}

- (void) sendMessageToLabel {
    
    NSString *message = self.sendMessageField.text;
    [self.networkConnection sendMessage:message];
}

#pragma mark - DeviceNetworkConnectionDelegate

-(void)recievedMessage:(NSString*) message {
    
    self.recievedMessageLabel.text = message;
}

@end
