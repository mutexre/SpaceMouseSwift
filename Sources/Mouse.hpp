//
//  3DMouseBridge.h
//  3D Mouse Test
//
//  Created by Alexander Obuschenko on 21/10/2018.
//  Copyright © 2018 mutexre. All rights reserved.
//

#pragma once

#import <Foundation/Foundation.h>
#import <3DconnexionClient/ConnexionClientAPI.h>

@class Mouse;

@protocol MouseDelegate

- (void)mouse:(Mouse*)mouse didReceiveTx:(float)tx ty:(float)ty tz:(float)tz
                                      rx:(float)rx ry:(float)ry rz:(float)rz;

@end

@interface Mouse : NSObject

@property (nonatomic, weak) id<MouseDelegate> delegate;
@property (nonatomic) UInt16 clientID;

+ (Mouse*)shared;
- (void)registerClient;

@end
