//
//  AudioView.m
//  FritzBox
//
//  Created by Leif Shackelford on 2/3/18.
//  Copyright © 2018 Leif Shackelford. All rights reserved.
//

#import "AudioView.h"

bool debug = 0;

@implementation AudioView

- (CGRect)rectWithPosition:(float)x yPos: (float) y width:(float) w height:(float) h {
    CGFloat iw = self.size.width;
    CGFloat ih = self.size.height;
    return CGRectMake(iw * x - (w * iw/2), ih * y - (h * ih / 2), w * iw, h * ih);
}

-(Button*)buttonWithAction:(Action)action xPos:(float)x yPos: (float) y width:(float) w height:(float) h {
    Button* button = [Button shapeNodeWithRect:[self rectWithPosition:x yPos:y width:w height:h]];
    button.action = action;
    if (debug){
        [button setFillColor: [UIColor colorWithRed:1 green:0 blue:0 alpha:1]];
    }
    return button;
}

-(Slider*)sliderWithAction:(SliderMoved)action xPos:(float)x yPos: (float) y width:(float) w height:(float) h {
    CGFloat iw = self.size.width;
    CGFloat ih = self.size.height;
    
    Slider* slider = [[Slider alloc]initWithTexture:nil color:[UIColor blackColor] size:CGSizeMake(w*iw,h*ih)];
    
    [slider setPosition:CGPointMake(x * iw, y * ih)];
    slider.action = action;
    return slider;
}

@end
