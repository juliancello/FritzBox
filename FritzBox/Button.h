//
//  Button.h
//  FritzBox
//
//  Created by Leif Shackelford on 2/2/18.
//  Copyright © 2018 Leif Shackelford. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

typedef void (^Action)(SKNode*, UITouch*);
typedef void (^SliderMoved)(SKNode*, CGPoint);

@interface SKNode(Additions)

- (void)touchDown:(UITouch*) t;
- (void)touchMoved:(UITouch*) t;

@end

@interface Button : SKShapeNode

@property (nonatomic, copy) Action action;
@property (nonatomic, copy) Action moveAction;

@end

@interface SpriteButton : SKSpriteNode

@property (nonatomic, copy) Action action;
@property (nonatomic, copy) Action moveAction;

@end

@interface TextButton : SKLabelNode

@property (nonatomic, copy) Action action;
@property (nonatomic, copy) Action moveAction;

@end

@class SliderCap;

@interface Slider : SKSpriteNode

@property (nonatomic, copy) SliderMoved action;
@property (nonatomic, strong) SliderCap *cap;

- (void)setFaderValue:(float)val;

@end

@interface SliderCap : Button
   @property (nonatomic, weak) Slider* ref;
@end
