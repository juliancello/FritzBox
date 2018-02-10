//
//  AudioView.h
//  FritzBox
//
//  Created by Leif Shackelford on 2/3/18.
//  Copyright © 2018 Leif Shackelford. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

#import "Button.h"
#import "Audio.h"

@protocol SceneRef <NSObject>
-(void)toggleView;
-(void)showCredits;
@end

@interface AudioView : SKSpriteNode

@property(weak) Audio* audio;
@property(weak) SKScene<SceneRef> *sceneRef;

-(Button*)buttonWithAction:(Action)action xPos:(float)x yPos: (float) y width:(float) w height:(float) h;
-(Slider*)sliderWithAction:(SliderMoved)action xPos:(float)x yPos: (float) y width:(float) w height:(float) h;


@end
