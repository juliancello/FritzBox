//
//  Audio.m
//  FritzBox
//
//  Created by Leif Shackelford on 2/2/18.
//  Copyright © 2018 Leif Shackelford. All rights reserved.
//

#import "Audio.h"

@import AVFoundation;

@implementation Deck {
    AVAudioEngine* _engine;
    NSMutableDictionary *_buffers;
    NSMutableDictionary *_players;
    NSMutableDictionary *_pitch;
}

-(instancetype)initWithEngine:(AVAudioEngine*)engine Files:(NSArray*) files inDirectory:(NSString*)dir {
    if (self = [super init]){
        _engine = engine;
        _mixer = [[AVAudioMixerNode alloc] init];
        [_engine attachNode:_mixer];

        
        _buffers = [[NSMutableDictionary alloc] init];
        _players = [[NSMutableDictionary alloc] init];
        _pitch = [[NSMutableDictionary alloc] init];
        
        for (NSString *name in files) {
            NSString* full = [NSString stringWithFormat:@"%@/%@", dir, name];
            NSString *path = [[NSBundle mainBundle] pathForResource:full ofType:@"wav"];
            AVAudioFile* audioFile = [[AVAudioFile alloc] initForReading:[NSURL fileURLWithPath:path]
                                                                   error:nil];
            
            NSError *error;
            AUAudioFrameCount frameCapacity = (AUAudioFrameCount)audioFile.length;
            AVAudioPCMBuffer *buf = [[AVAudioPCMBuffer alloc] initWithPCMFormat:audioFile.processingFormat frameCapacity:frameCapacity];
            
            bool success = [audioFile readIntoBuffer:buf error:&error];
            if (success && !error){
                AVAudioPlayerNode* player = [AVAudioPlayerNode new];
                [_engine attachNode:player];
                if (!_format){
                    _format = audioFile.processingFormat;
                   
                }
                
                AVAudioUnitVarispeed *varispeed = [AVAudioUnitVarispeed new];
                [_engine attachNode:varispeed];
                [_engine connect:varispeed to:_mixer format:_format];
                [_engine connect:player
                              to:varispeed
                          format:_format];
                
                _pitch[name] = varispeed;
                _buffers[name] = buf;
                _players[name] = player;
            }
        }
    }
    
    return self;
}

-(void)muteAll{
    for (NSString* name in _players.allKeys) {
        AVAudioPlayerNode *player = _players[name];
        player.volume = 0;
    }
}

-(void)setRate:(float)rate {
    for (NSString* name in _pitch.allKeys) {
        AVAudioPlayerNode *varispeed = _pitch[name];
        [varispeed setRate:rate];
    }
    _boostVolume = (1.0 / rate);
    [self updateVolume];
}

-(void)loopAll:(AVAudioTime *) startTime {
    for (NSString* name in _players.allKeys) {
        AVAudioPlayerNode *player = _players[name];
        [player scheduleBuffer:_buffers[name] atTime:nil options:AVAudioPlayerNodeBufferLoops completionHandler:nil];
        if(startTime == nil) {
            const float kStartDelayTime = 0.5; // sec
            AVAudioFormat *outputFormat = [player outputFormatForBus:0];
            AVAudioFramePosition startSampleTime = player.lastRenderTime.sampleTime + kStartDelayTime * outputFormat.sampleRate;
            startTime = [AVAudioTime timeWithSampleTime:startSampleTime atRate:outputFormat.sampleRate];
        }
        [player playAtTime:startTime];
    }
}

-(void)reconnect {
    for ( NSString *name in _players.allKeys) {
        
         AVAudioUnitVarispeed *varispeed =  _pitch[name];
        AVAudioPlayerNode *player = _players[name];
        
        [_engine connect:varispeed to:_mixer format:_format];
        [_engine connect:player
                      to:varispeed
                  format:_format];
    }
}

-(void)resumeAll {
     for ( AVAudioPlayerNode *player in _players.allValues) {
          [player playAtTime:nil];
     }
}

-(void)playBuffer:(NSString*) name {
    AVAudioPlayerNode *player = _players[name];
    [player scheduleBuffer:_buffers[name] atTime:nil options:AVAudioPlayerNodeBufferInterrupts completionHandler:nil];
    if (!player.isPlaying){
        [player play];
    }
}

-(void)updateVolume {
    [_mixer setVolume:_mixVolume * _normalVolume * _boostVolume ];
}

-(void)setVolume:(NSString*)name volume:(float)volume {
    AVAudioPlayer* p = _players[name];
    p.volume = volume;
}

@end

@implementation Audio

+(NSArray*)voxSounds {
    return @[@"coolSolo", @"great", @"iSeeWhatYoureSaying", @"juhu", @"radler", @"reims", @"rhubarber", @"rrreims", @"theChicken", @"told",@"bassoon",@"partyRoom",@"cackle",@"carlTheIceberg",@"congrats",@"cutter",@"cuttlefish",@"dontKnow",@"greatNippleSong",@"imNotARapper",@"killayKillayKillay",@"orangeTrashCan", @"punchHimInTheNose", @"pure", @"shark", @"sorryForMyHonesty", @"whatDoesTheDongleDo"];
}

-(void)setCrossFader:(float) mix{
    _left.mixVolume = mix > .5 ? (1.0 - mix) : 1.0;
    _right.mixVolume =  mix < .5 ? mix : 1.0;
    
        [_left updateVolume];
        [_right updateVolume];
}

-(void)setDelayControl:(CGPoint) val {
    float a = val.x;
    float r = val.y;
    [_echo setWetDryMix:(a * a * a * 100.0)];
    [_echo setFeedback: (a * a * 70.0) + 30];
    [_echo setLowPassCutoff:((1.0-a)*6000.0) + 6000];
    if (a > .75){
        if (r > .6){
            [_echo setDelayTime:.1];
        } else if (r < .4){
            [_echo setDelayTime:1.0];
        } else {
            [_echo setDelayTime:.33];
        }
    }
}

-(void)handleInterruption:(AVAudioEngine*)engine {
    NSLog(@"reset audio engine");
    if ([self start]){
        [_engine reset];
        [self reconnect];

        AVAudioTime *time = nil;
        [_left loopAll: time];
        [_right loopAll: time];
    }
}

-(void)audioHardwareRouteChanged:(id)arg{
    NSLog(@"audioHardwareRouteChanged");
}

- (instancetype)initWithEngine:(AVAudioEngine*) engine {
    self = [super init];
    
    _engine = engine;
    if (!_engine){
        _engine = [[AVAudioEngine alloc]init];
    }
    
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayAndRecord  withOptions:AVAudioSessionCategoryOptionMixWithOthers|AVAudioSessionCategoryOptionDefaultToSpeaker error:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector:@selector(handleInterruption:)
                                                 name:AVAudioEngineConfigurationChangeNotification
                                               object:_engine];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(audioHardwareRouteChanged:) name:AVAudioSessionRouteChangeNotification object:nil];
    
    // Prepare AVAudioFile
    NSArray* paths = @[@"drums", @"bass",@"rhythm", @"lead"];
    
    _left = [[Deck alloc]initWithEngine:_engine Files:paths inDirectory:@"samples/leif"];
    _right = [[Deck alloc]initWithEngine:_engine Files:paths inDirectory:@"samples/fritz"];
    
    _vox = [[Deck alloc]initWithEngine:_engine Files:[Audio voxSounds] inDirectory:@"samples/vox"];
    
    _echo = [AVAudioUnitDelay new];
    
    [_engine attachNode:_echo];
    
    [self reconnect];
    
    [_echo setWetDryMix:0];
    [_echo setFeedback:0];
    [_echo setDelayTime:.33];
    
    _left.normalVolume = 1.8;
    _right.normalVolume = .5;
    _left.mixVolume = 1.0;
    _right.mixVolume = 1.0;
    _left.boostVolume = 1.0;
    _right.boostVolume = 1.0;
    
    [_left updateVolume];
    [_right updateVolume];
    
    // Start engine
    if ([self start]){
        AVAudioTime *time = nil;
        [_left loopAll: time];
        [_left muteAll];
        [_right loopAll: time];
        [_right muteAll];
    }
    
    return self;
}

-(void)reconnect {
    [_left reconnect];
    [_engine connect:_left.mixer
                  to:[_engine mainMixerNode]
              format:_left.format];
    
    [_right reconnect];
    [_engine connect:_right.mixer
                  to:[_engine mainMixerNode]
              format:_right.format];
    
    [_vox reconnect];
    [_engine connect:_vox.mixer
                  to:_echo
              format:_vox.format];
    
    [_engine connect:_echo
                  to:[_engine mainMixerNode]
              format:_vox.format];
}

-(bool)start {
    if (_engine.isRunning){
        return true;
    }
    NSError *error;
    [_engine startAndReturnError:&error];
    if (error) {
        NSLog(@"error:%@", error);
        return false;
    } else {
        NSLog(@"audio engine loaded");
        return true;
    }
}

@end

