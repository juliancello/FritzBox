//
//  GameScene.h
//  FritzBox
//
//  Created by Leif Shackelford on 1/31/18.
//  Copyright © 2018 Leif Shackelford. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "Audio.h"

@interface GameScene : SKScene

@property(nonatomic, strong) Audio* audio;

-(void)toggleView;
-(void)showCredits;

@end
