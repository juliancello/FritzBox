//
//  Box.m
//  FritzBox
//
//  Created by Leif Shackelford on 2/1/18.
//  Copyright © 2018 Leif Shackelford. All rights reserved.
//

#import "Box.h"


NSString *toVox = @"VOX ->";
NSString *toBox = @"ZOOM";

@implementation Tracks

-(void)setPlaying:(bool) playing {
    if (playing){
        if (!_playing){
            [_spinner removeAllActions];
            [_spinner runAction:[SKAction repeatActionForever:[SKAction rotateByAngle:-M_PI duration:1]]];
            [_deck setRate: 1.0];
        }
    } else {
        if (_playing){
            [_spinner removeAllActions];
            [_spinner runAction:[SKAction repeatActionForever:[SKAction rotateByAngle:-M_PI duration:2]]];
            [_deck setRate: .5];
        }
    }
    _playing = playing;
}

-(void)toggleTrack:(SKNode*) track {
    bool on = track.alpha >= 1;
    [track setAlpha: on ? .5 : 1];
//    [track setColor:[UIColor colorWithHue:(random() % 1024) / 1024. saturation:1.0 brightness:1.0 alpha:on ? .9 : 1]];
    [_deck setVolume:track.name volume: 1.0 - on];
}

@end

@implementation Box {
    SKSpriteNode *_lspinner;
    Tracks *_ltracks;
    
    SKSpriteNode *_rspinner;
    Tracks *_rtracks;
    
    Button *_crossFader;
    
    TextButton *_fritzBox;
    TextButton *_label;
    
    Audio* _audio;
}

-(SpriteButton*)spriteButton:(Action)action imageNamed:(NSString*)string xPos:(float)x yPos: (float) y {
    SpriteButton* button = [SpriteButton spriteNodeWithImageNamed:@"Spinner"];
     CGSize s = self.size;
    [button setPosition:CGPointMake(s.width * x, s.height * y)];
    button.action = action;
    return button;
}

-(TextButton*)textButton:(Action)action text:(NSString*)string xPos:(float)x yPos: (float) y {
    TextButton* button = [TextButton labelNodeWithFontNamed:@"Marker Felt"];
    [button setText:string];
    [button setFontColor:[UIColor blackColor]];
    [button setFontSize:100];
    [button setYScale:1.1];
    [button setAlpha:.6];
    CGSize s = self.size;
    [button setPosition:CGPointMake(s.width * x, s.height * y)];
    button.action = action;
    return button;
}

- (instancetype)initWithTexture:(SKTexture *)texture color:(UIColor *)color size:(CGSize)size {
    self = [super initWithTexture:texture color:color size:size];

    _fritzBox = [self textButton:^(SKNode* node, UITouch *t){
        [self.sceneRef showCredits];
    } text:@"FRITZ BOX" xPos:0 yPos:.28];
    [_fritzBox setFontSize:130];
    [_fritzBox setAlpha:1.0];
    [self addChild:_fritzBox];
    
    _label = [self textButton:^(SKNode* node, UITouch *t){
        [self toggleView];
    } text:toVox xPos:0 yPos:-.42];
    [_label setAlpha:1.0];
    [_label setFontSize:130];
    [self addChild:_label];

    _lspinner = [self spriteButton:^(SKNode* node, UITouch *t){
        [_ltracks setPlaying:!_ltracks.playing];
        [_rtracks setPlaying:!_rtracks.playing];
    } imageNamed:@"Spinner" xPos:-.175 yPos:.105];
    [self addChild:_lspinner];
    
    _ltracks = [[Tracks alloc] init];
    [_ltracks setSpinner: _lspinner];
    [_ltracks setPlaying:true];

    TextButton* button;
        
    float lx = -.35;
    float rx = .34;
    float h = .26;
    float y = .13;
    
    button = [self textButton:^(SKNode* node, UITouch *t){
        [_ltracks toggleTrack:node];
    } text:@"DRUMS" xPos:lx yPos:h-y*0];
    button.name = @"drums";
    [_ltracks setDrums: button];

    button = [self textButton:^(SKNode* node, UITouch *t){
        [_ltracks toggleTrack:node];
    } text:@"BASS" xPos:lx yPos:h-y*1.0];
    button.name = @"bass";
    [_ltracks setBass: button];
    
    button = [self textButton:^(SKNode* node, UITouch *t){
        [_ltracks toggleTrack:node];
    } text:@"RHYTHM" xPos:lx yPos:h-y*2.0];
    button.name = @"rhythm";
    [_ltracks setRhythm: button];
    
    button = [self textButton:^(SKNode* node, UITouch *t){
        [_ltracks toggleTrack:node];
    } text:@"LEAD" xPos:lx yPos:h-y*3.0];
    button.name = @"lead";
    [_ltracks setLead: button];
    
    [self addChild:_ltracks.drums];
    [self addChild:_ltracks.bass];
    [self addChild:_ltracks.rhythm];
    [self addChild:_ltracks.lead];
    
    _rspinner = [self spriteButton:^(SKNode* node, UITouch *t){
        [_ltracks setPlaying:!_ltracks.playing];
        [_rtracks setPlaying:!_rtracks.playing];
    } imageNamed:@"Spinner" xPos:.163 yPos:.105];
    [self addChild:_rspinner];
    
    _rtracks = [[Tracks alloc] init];
    [_rtracks setSpinner: _rspinner ];
    [_rtracks setPlaying:true];

    button = [self textButton:^(SKNode* node, UITouch *t){
        [_rtracks toggleTrack:node];
    } text:@"DRUMS" xPos:rx yPos:h-y*0];
    button.name = @"drums";
    [_rtracks setDrums: button];
    
    button = [self textButton:^(SKNode* node, UITouch *t){
        [_rtracks toggleTrack:node];
    } text:@"BASS" xPos:rx yPos:h-y*1];
    button.name = @"bass";
    [_rtracks setBass: button];
    
    button = [self textButton:^(SKNode* node, UITouch *t){
        [_rtracks toggleTrack:node];
    } text:@"RHYTHM" xPos:rx yPos:h-y*2];
    button.name = @"rhythm";
    [_rtracks setRhythm: button];
    
    button = [self textButton:^(SKNode* node, UITouch *t){
        [_rtracks toggleTrack:node];
    } text:@"LEAD" xPos:rx yPos:h-y*3];
    button.name = @"lead";
    [_rtracks setLead: button];

    [self addChild:_rtracks.drums];
    [self addChild:_rtracks.bass];
    [self addChild:_rtracks.rhythm];
    [self addChild:_rtracks.lead];

    float csY = -.112;
    Box* weakSelf = self;
    _crossFader = [self buttonWithAction:^(SKNode* node, UITouch *t){
    } xPos:0 yPos:csY width:.04 height:.16];
    _crossFader.moveAction = ^(SKNode* node, UITouch *t) {
        CGPoint pos = [t locationInNode:weakSelf];
        [weakSelf crossFade:pos];
    };
    [_crossFader setFillColor:[UIColor blackColor]];
    [self addChild:_crossFader];
    
    return self;
}

-(void)toggleView {
    [self.sceneRef toggleView];
    if ([_label.text isEqual: toVox]){
        _label.text = toBox;
    } else {
        _label.text = toVox;
    }
}

-(void)setAudio:(Audio *)audio {
    if (audio){
        _ltracks.deck = audio.left;
        _rtracks.deck = audio.right;
    }
    _audio = audio;
}

- (void)crossFade:(CGPoint)pos {
    NSLog(@"%f", pos.x);
    float w = self.size.width;
    
    float throw = self.sceneRef.size.width * .67;
    float x = MAX(MIN(throw, pos.x), -throw);
    [_crossFader setPosition:CGPointMake(x, 0)];
    
    float n = x / throw;
    float f = n / 2 + .5;
    [_audio setCrossFader:f];
}

- (void)touchDown:(UITouch*)t {
//    NSLog(@"touch on box");
//    CGSize s = self.size;
//    NSLog(@"%1.3f : %1.3f", ((-s.width / 2) + pos.x) / s.width, ((-s.height / 2) + pos.y) / s.height);
    if ([_label.text isEqual:toBox]){
        [self toggleView];
    }
}

- (void)touchMoved:(UITouch*)t {
//    NSLog(@"touch on box");
//    CGSize s = self.size;
//    if ((pos.x > (s.width / 4)) && (pos.x < (s.width * 3 / 4))){
//        [self crossFade:pos];
//    }
//    NSLog(@"%1.3f : %1.3f", pos.x, (s.width / 3));
}


@end
