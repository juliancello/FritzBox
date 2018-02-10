//
//  GameScene.m
//  FritzBox
//
//  Created by Leif Shackelford on 1/31/18.
//  Copyright © 2018 Leif Shackelford. All rights reserved.
//

#import "GameScene.h"
#import "Box.h"
#import "Vox.h"

@implementation GameScene {
    Box *_box;
    Vox *_vox;
    
    SKNode *_currentView;
//    NSMutableDictionary *_tMap;
    NSMapTable *_tMap;
    
    float _scale;
}

-(instancetype)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]){
//        _tMap = [[NSMutableDictionary alloc]init];
        _tMap = [[NSMapTable alloc] init];
        _audio = [[Audio alloc] initWithEngine:self.audioEngine];
        
    }
    return self;
}

- (void)didMoveToView:(SKView *)view {
    _box = [Box spriteNodeWithImageNamed:@"DJ_Background"];
    _box.sceneRef = self;
    
    CGSize s = view.bounds.size;
    
    float cs = view.contentScaleFactor;
    
    _vox = [[Vox alloc]initWithTexture:nil color:[UIColor whiteColor] size:CGSizeMake(s.width*3,s.height*3)];
    _vox.sceneRef = self;
    
    NSLog(@"init with scale, %f", view.contentScaleFactor);
    

//    _scale = 1/view.contentScaleFactor;
    _scale = s.width / 1920;
    
    
    [_box setPosition: CGPointMake(s.width/2, s.height/2)];
    [_box setScale:_scale];
    
    [_vox setPosition: CGPointMake(s.width/2, s.height/2)];
    [_vox setScale:.33];
    
    [self addChild:_vox];
    [self addChild:_box];
    
    [_box setAudio:_audio];
    [_vox setAudio:_audio];
    
    [self toggleView];
    [_box toggleView];
    
    [_vox displayPage:0];
}

-(void)toggleView {
    float speed = .3;
    if (_currentView == _box){
        CGSize s = self.size;
        [_box runAction:
         [SKAction group:@[
                           [SKAction moveTo: CGPointMake(s.width*.22, s.height*.69) duration:speed],
                           [SKAction scaleTo:_scale/3.2 duration:speed]
                           ]]];
        _currentView = _vox;
    } else {
        CGSize s = self.size;
        [_box runAction:
         [SKAction group:@[
                           [SKAction moveTo: CGPointMake(s.width/2, s.height/2) duration:speed],
                           [SKAction scaleTo:_scale duration:speed]
                           ]]];
        _currentView = _box;
    }
    
}

-(void)showCredits {
    [self addChild:[self credits]];
}


-(TextButton*)label:(NSString*)text {
    TextButton *label = [TextButton labelNodeWithFontNamed:@"Marker Felt"];
    [label setFontColor:[UIColor blackColor]];
    [label setFontSize:42];
    [label setYScale:1.1];
    [label setText:text];
    return label;
}

-(SKSpriteNode*)credits {
    NSArray* lines = @[
                @"Code: Leif Shackelford",
                @"Voice: Fritz Brückner",
                @"Audio:",
                @"Erika Anderson", @"Brent Knopf", @"Susan Lucia",
                @"Driving: Mirko Spino"
                ];
    
    SpriteButton* credits = [[SpriteButton alloc]initWithTexture:nil color:[UIColor whiteColor] size:CGSizeMake(1920,1080)];

    for (int i = 0; i < lines.count; i++) {
        TextButton* line = [self label:lines[i]];
        [line setPosition:CGPointMake(0, self.size.height*.33 - (i*self.size.height*.12))];
        line.action = ^(SKNode* n, UITouch *t){
            [credits removeFromParent];
        };
        [credits addChild:line];
        
    }
    
    credits.action = ^(SKNode* n, UITouch *t){
        [n removeFromParent];
    };
    
    [credits setPosition:CGPointMake(self.size.width*.5, self.size.height*.5)];
    return credits;
}
- (void)touchDown:(UITouch*) t{
    CGPoint pos = [t locationInNode:self];
    SKNode* node = [self nodeAtPoint:pos];
    [_tMap setObject:node forKey:t];
    [node touchDown: t];
}

- (void)touchMoved:(UITouch*) t {
    SKNode *existing = [_tMap objectForKey:t];
    if (existing){
        [existing touchMoved: t];
    }
}

- (void)touchUpAtPoint:(CGPoint)pos ref:(UITouch*) t {
    [_tMap removeObjectForKey:t];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *t in touches) {[self touchDown: t];}
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    for (UITouch *t in touches) {[self touchMoved: t];}
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *t in touches) {[self touchUpAtPoint:[t locationInNode:self] ref: t];}
}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *t in touches) {[self touchUpAtPoint:[t locationInNode:self] ref: t];}
}

-(void)update:(CFTimeInterval)currentTime {
    // Called before each frame is rendered
}

@end

