//
//  Audio.h
//  FritzBox
//
//  Created by Leif Shackelford on 2/2/18.
//  Copyright © 2018 Leif Shackelford. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

@interface Deck : NSObject

@property(strong, nonatomic) AVAudioMixerNode* mixer;
@property(assign) float normalVolume;
@property(assign) float mixVolume;
@property(assign) float boostVolume;
@property(strong, nonatomic) AVAudioFormat* format;

-(void)setVolume:(NSString*)name volume:(float)volume;
-(void)muteAll;
-(void)setRate:(float)rate;
-(void)playBuffer:(NSString*) name;

@end

@interface Audio : NSObject

+(NSArray*)voxSounds;

@property (nonatomic, strong) AVAudioEngine *engine;
@property (nonatomic, strong) Deck *left;
@property (nonatomic, strong) Deck *right;
@property (nonatomic, strong) Deck *vox;

@property (nonatomic, strong) AVAudioUnitDelay* echo;

- (instancetype)initWithEngine:(AVAudioEngine*) engine;
-(void)setCrossFader:(float) mix;
-(void)setDelayControl:(CGPoint) val;

@end

