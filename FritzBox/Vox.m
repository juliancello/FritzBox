//
//  Vox.m
//  FritzBox
//
//  Created by Leif Shackelford on 2/1/18.
//  Copyright © 2018 Leif Shackelford. All rights reserved.
//

#import "Vox.h"

@implementation Vox {
    TextButton *_fritzVox;
    
    SKNode *_buttonLayer;
    
    Slider *_delayControl;
    
    NSArray *_sounds;
    NSDictionary *_labels;
}

-(TextButton*)textButton:(Action)action text:(NSString*)string xPos:(float)x yPos: (float) y {
    TextButton* button = [TextButton labelNodeWithFontNamed:@"Marker Felt"];
    [button setText:string];
    [button setFontColor:[UIColor blackColor]];
    [button setFontSize:100];
    [button setYScale:1.1];
    CGSize s = self.size;
    [button setPosition:CGPointMake(s.width * x, s.height * y)];
    button.action = action;
    return button;
}

-(Button*)textBox:(Action)action text:(NSString*)string xPos:(float)x yPos: (float) y width: (float) w height: (float) h {
    CGSize s = self.size;
    Button* button = [Button shapeNodeWithRectOfSize: CGSizeMake(s.width * w , s.height * h) cornerRadius:12];
    [button setLineWidth:4.0];
    [button setStrokeColor:[UIColor blackColor]];
    
    TextButton *label = [TextButton labelNodeWithFontNamed:@"Marker Felt"];
    
    if (_labels[string]){
        [label setText:_labels[string]];
    } else {
        NSString *str = [NSString stringWithFormat:@"%@%@",
                         [string substringToIndex:1].uppercaseString,
                         [string substringFromIndex:1]];
        [label setText: str];
    }
    
    [label setFontColor:[UIColor blackColor]];
    [label setFontSize:76];
    [label setYScale:1.1];
    [label setPosition:CGPointMake(0, -h*s.height*.2)];
    
    [button addChild:label];
    [button setPosition:CGPointMake(s.width * x, s.height * y)];
    
    button.action = action;
    label.action = action;
    
    return button;
}

- (instancetype)initWithTexture:(SKTexture *)texture color:(UIColor *)color size:(CGSize)size {
    self = [super initWithTexture:texture color:color size:size];
    _fritzVox = [self textButton:^(SKNode* node, UITouch *t){
        [self.sceneRef showCredits];
    } text:@"FRITZ VOX" xPos:-.28 yPos:.37];
    [_fritzVox setAlpha:1.0];
    [_fritzVox setFontSize:130];
    [self addChild:_fritzVox];
    
    Vox *ws = self;
    _delayControl = [self sliderWithAction:^(SKNode* node, CGPoint val){
        [ws.audio setDelayControl:val];
    } xPos:-.23 yPos:-.03 width:.19 height:.08];
    [_delayControl setFaderValue:0];
    [self addChild:_delayControl];
    
    TextButton *space = [self textButton:^(SKNode *node, UITouch *t) {
    } text:@"ECHO" xPos:-.395 yPos:-.05];
    
    [space setFontSize:60];
    [self addChild:space];
    
    SKNode *pageLayer = [[SKNode alloc]init];
    [self addChild:pageLayer];
    
    [pageLayer setPosition:CGPointMake(size.width * -.36, size.height * -.45)];
    
    for (int i = 0; i < 2; i++) {
        for (int j = 0; j < 2; j++) {
            int page = i+j*2;
            if (page == 3) break;
            float x = i*.16;
            float y = .275 - j * .172;
            NSString *name = [NSString stringWithFormat:@"%d", page + 1];
            [pageLayer addChild: [self textBox:^(SKNode* node, UITouch* pos) {
                [self displayPage: page];
            } text:name xPos:x yPos:y width:.15 height:.158]];
        }
    }
    
    _labels = @{
                @"coolSolo": @"Cool Solo",
                @"iSeeWhatYoureSaying": @"I See...",
                @"theChicken": @"The Chicken",
                @"carlTheIceberg": @"Carl Iceberg",
                @"imNotARapper": @"Not a Rapper",
                @"greatNippleSong": @"Nipple Song",
                @"killayKillayKillay": @"Killay",
                @"orangeTrashCan": @"Trash Can",
                @"dontKnow": @"Don't Know",
                @"punchHimInTheNose": @"Punch Him",
                @"sorryForMyHonesty": @"Sorry...",
                @"whatDoesTheDongleDo": @"The Dongle"
                };  // TODO: replace labels to match gvox Audio.m
    _sounds = [Audio voxSounds];
    _buttonLayer = [[SKNode alloc]init];
    [self addChild:_buttonLayer];
    
    return self;
}

-(void)displayPage:(int) page {
    [_buttonLayer removeAllChildren];
    for (int i = 0; i < 2; i++) {
        for (int j = 0; j < 5; j++) {
            int index = i+j*2 + (page*10);
            if (_sounds.count > index) {
                float x = .15 + (i*.8);
                float y = 1.0 - j * .5;
                NSString *name = _sounds[index];
                [_buttonLayer addChild: [self textBox:^(SKNode* node, UITouch* pos) {
                    [_deck playBuffer:name];
                } text:name xPos:x yPos:y width:.75 height:.45]];
            }
        }
    }
}

-(void)setAudio:(Audio *)audio {
    [super setAudio:audio];
    if (audio){
        _deck = audio.vox;
    }
}

- (void)touchDown:(UITouch*)t {
}

- (void)touchMoved:(UITouch*)t {
}


@end

