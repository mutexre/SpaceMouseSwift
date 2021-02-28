//
//  3DMouseBridge.m
//  3D Mouse Test Host
//
//  Created by Alexander Obuschenko on 21/10/2018.
//  Copyright © 2018 mutexre. All rights reserved.
//

#import <assert.h>
#import "Mouse.hpp"

void connexionAddedHandlerProc(unsigned int productID)
{
    printf("Added %u\n", productID);
//    [Mouse.shared connect];
}

void connexionRemovedHandlerProc(unsigned int productID)
{
    printf("Removed %u\n", productID);
}

void connexionMessageHandlerProc(unsigned int productID, unsigned int messageType, void *messageArgument)
{
    NSLog(@"%u", messageType);
    
    auto clientID = Mouse.shared.clientID;
    
    switch (messageType)
    {
        case kConnexionMsgDeviceState:
        {
            auto state = (ConnexionDeviceState*)messageArgument;
//            if (state->client == clientID)
            {
                switch (state->command)
                {
                    case kConnexionCmdHandleAxis:
                    {
                        auto data = state->axis;
                        NSLog(@"%d %d %d", data[0], data[1], data[2]);
                        
                        float tx = float(data[0]) / 255.0;
                        float ty = float(data[1]) / 255.0;
                        float tz = float(data[2]) / 255.0;
                        
                        float rx = float(data[3]) / 255.0;
                        float ry = float(data[4]) / 255.0;
                        float rz = float(data[5]) / 255.0;
                        
                        [Mouse.shared.delegate mouse: Mouse.shared
                                        didReceiveTx: tx
                                                  ty: ty
                                                  tz: tz
                                                  rx: rx
                                                  ry: ry
                                                  rz: rz];
                    }
                    break;
                    
                    case kConnexionCmdHandleButtons:
                    break;
                }
            }
        }
        break;

        default: break;
    }
}

@implementation Mouse

+ (id)shared
{
    static Mouse* sharedInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

- (id)init
{
    if (self = [super init])
    {
        uint16_t result = SetConnexionHandlers(connexionMessageHandlerProc,
                                               connexionAddedHandlerProc,
                                               connexionRemovedHandlerProc,
                                               false);
        assert(result == 0);
    
        [self registerClient];
    
        return self;
    }
    return nil;
}

- (void)dealloc
{
    UnregisterConnexionClient(self.clientID);
    CleanupConnexionHandlers();
}

- (void)registerClient
{
    self.clientID =
        RegisterConnexionClient(0, (uint8_t*)"3D Mouse Test Host",
                                kConnexionClientModeTakeOver,
                                kConnexionMaskAll);
}

@end
