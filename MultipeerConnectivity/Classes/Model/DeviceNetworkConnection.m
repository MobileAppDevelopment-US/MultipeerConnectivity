//
//  MCManager.m
//  MultipeerConnectivity
//
//  Created by User on 09.10.17.
//  Copyright © 2017 Serik_Klement. All rights reserved.
//

#import "DeviceNetworkConnection.h"

NSString *const kServiceType = @"exchange";

@interface DeviceNetworkConnection ()

@property (nonatomic, strong) MCPeerID *peerID;
@property (nonatomic, strong) MCAdvertiserAssistant *advertiser;
@property (nonatomic, strong) MCSession *session;
@property (nonatomic, strong) NSInputStream *inputStream;
@property (nonatomic, strong) NSOutputStream *outputStream;
@property (nonatomic, assign) NSInteger lengthData;

@end

@implementation DeviceNetworkConnection

#pragma mark - Methods

- (void)startAdvertising {

    NSString *deviceName = [[UIDevice currentDevice] name];
    self.peerID = [[MCPeerID alloc] initWithDisplayName:deviceName];
    self.session = [[MCSession alloc] initWithPeer:self.peerID];
    self.session.delegate = self;
    self.advertiser = [[MCAdvertiserAssistant alloc] initWithServiceType:kServiceType
                                                           discoveryInfo:nil
                                                                 session:self.session];
    self.browser = [[MCBrowserViewController alloc] initWithServiceType:kServiceType
                                                                session:self.session];
    self.browser.delegate = self;
}

- (void) isStarting {
    
    [self.advertiser start];
}

- (void) isStopping {
    
    [self.advertiser stop];
}

- (void) sendMessage:(NSString*) message {
    
    NSData *data = [message dataUsingEncoding:(NSUTF8StringEncoding)];
    NSError *error = nil;
    
    if (![self.session sendData:data
                        toPeers:self.session.connectedPeers
                       withMode:MCSessionSendDataReliable
                          error:&error]) {
        NSLog(@"[Error] %@", error);
    }
}

- (void) sendPoint:(DrawingPoint*)modelPoint {

    NSData *data=[NSKeyedArchiver archivedDataWithRootObject:modelPoint];
    // делаю интеджер и передаю в поток  - длинну даты так как она не передавалась
    NSInteger length = data.length;
    NSData *dataInt = [NSData dataWithBytes:&length length:sizeof(NSInteger)];
    
    [self.outputStream write:dataInt.bytes maxLength:dataInt.length];
    [self.outputStream write:data.bytes maxLength:data.length];
}

#pragma mark - MCSessionDelegate

- (void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *message = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        [self.delegate recievedMessage:message];
    });
}

- (void)session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress {

    NSLog(@"didStartReceivingResourceWithName");
}

- (void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state {

    NSLog(@">>>state - %ld", (long)state);

    if (state == MCSessionStateConnected) {
        
        self.outputStream = [self.session startStreamWithName:@"streamName"
                                                       toPeer:[self.session connectedPeers][0]
                                                        error:nil];
        self.outputStream.delegate = self;
        [self.outputStream scheduleInRunLoop:[NSRunLoop mainRunLoop]
                                     forMode:NSDefaultRunLoopMode];
        [self.outputStream open];
    }
}

- (void)session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(NSError *)error {

    NSLog(@"didFinishReceivingResourceWithName");
}

- (void)session:(MCSession *)session didReceiveCertificate:(NSArray *)certificate fromPeer:(MCPeerID *)peerID certificateHandler:(void (^)(BOOL accept))certificateHandler {

    certificateHandler(true);
}

// поток сразу попадает сюда - проверить статус потока self.inputStream.streamStatus
- (void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID {
    
    // получаю входящий поток
    self.inputStream = stream;
    self.inputStream.delegate = self;
    [self.inputStream scheduleInRunLoop:[NSRunLoop mainRunLoop]
                                forMode:NSDefaultRunLoopMode];
    [self.inputStream open]; // открываю входящий поток
}

#pragma mark - NSStreamDelegate

// получаю поток сюда и беру из него данные
- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode {
    
    NSLog(@">>>eventCode = %lu", (unsigned long)eventCode);
    if (NSStreamEventHasBytesAvailable == eventCode && aStream == self.inputStream) {
        
        if (self.lengthData == 0) {
            uint8_t bufferFirst[sizeof(NSInteger)];
            [self.inputStream read:bufferFirst maxLength:sizeof(NSInteger)];
            NSData *dataInt = [NSData dataWithBytes:bufferFirst length:sizeof(bufferFirst)];
            NSInteger length;
            [dataInt getBytes:&length length:sizeof(length)];
            self.lengthData = length;
        } else {
            // read from the stream
            uint8_t bufferSecond[self.lengthData];
            // получаю data из потока
            [self.inputStream read:bufferSecond maxLength:self.lengthData];
            NSData *dataModel = [NSData dataWithBytes:bufferSecond length:sizeof(bufferSecond)];
            
            // получаю модель из data и передаю модель на отрисовку в ShowView
            DrawingPoint *drawingPoint = [NSKeyedUnarchiver unarchiveObjectWithData:dataModel];
            [self.delegate recievedDrawingPoint:drawingPoint];
            self.lengthData = 0;
        }
    }
}

#pragma mark - MCBrowserViewControllerDelegate

- (void)browserViewControllerDidFinish:(MCBrowserViewController *)browserViewController {
    
    [browserViewController dismissViewControllerAnimated:true completion:nil];
}

- (void)browserViewControllerWasCancelled:(MCBrowserViewController *)browserViewController {
    
    [browserViewController dismissViewControllerAnimated:true completion:nil];
}

@end
