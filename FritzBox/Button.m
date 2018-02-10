//
//  Button.m
//  FritzBox
//
//  Created by Leif Shackelford on 2/2/18.
//  Copyright © 2018 Leif Shackelford. All rights reserved.
//

#import "Button.h"


@implementation Button

- (void)touchDown:(UITouch*)t {
    if (_action){
        _action(self, t);
    }
}

- (void)touchMoved:(UITouch*)t {
    if (_moveAction){
        _moveAction(self, t);
    }
}

@end

@implementation SliderCap

- (void)touchDown:(UITouch*)t {
    [_ref touchDown: t];
}

- (void)touchMoved:(UITouch*)t {
    [_ref touchMoved: t];
}

@end

@implementation Slider

- (instancetype)initWithTexture:(SKTexture *)texture color:(UIColor *)color size:(CGSize)size {
    UIColor *_color = color ? color : [UIColor blackColor];
    self = [super initWithTexture:texture color:_color size:CGSizeMake(size.width, size.height / 8)];
    
    _cap = [SliderCap shapeNodeWithRectOfSize:CGSizeMake(size.width / 6, size.height)];
    _cap.ref = self;
    [_cap setFillColor:[UIColor blackColor]];
    [_cap setLineWidth:0];
    
    [self addChild:_cap];
    
    return self;
}

- (void)setFaderValue:(float)val {
    [_cap setPosition:CGPointMake(self.size.width * val - (self.size.width / 2), 0)];
}

- (void)touchDown:(UITouch*)t {
    [self touchMoved: t];
}

- (void)touchMoved:(UITouch*)t {
    CGPoint pos = [t locationInNode:self];
    float throw = self.size.width * .5;
    float x = MAX(MIN(throw, pos.x), -throw);
    float y = MAX(MIN(throw, pos.y), -throw);
    
    float fx = (x / throw) / 2 + .5;
    float fy = (y / throw) / 2 + .5;
    
    [_cap setPosition:CGPointMake(x, 0)];
    if (_action){
        _action(self, CGPointMake(fx, fy));
    }
}

@end

@implementation SpriteButton

- (void)touchDown:(UITouch*)t {
    if (_action){
        _action(self, t);
    }
}

- (void)touchMoved:(UITouch*)t {
    if (_moveAction){
        _moveAction(self, t);
    }
}

@end

@implementation TextButton

- (void)touchDown:(UITouch*)t {
    if (_action){
        _action(self, t);
    }
}

- (void)touchMoved:(UITouch*)t {
    if (_moveAction){
        _moveAction(self, t);
    }
}

@end

