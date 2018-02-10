//
//  Box.h
//  FritzBox
//
//  Created by Leif Shackelford on 2/1/18.
//  Copyright © 2018 Leif Shackelford. All rights reserved.
//

#import "AudioView.h"

@interface Tracks : NSObject

@property(assign) bool playing;
@property(strong) TextButton *drums;
@property(strong) TextButton *bass;
@property(strong) TextButton *rhythm;
@property(strong) TextButton *lead;
@property(strong) SKSpriteNode *spinner;

@property(weak) Deck* deck;

@end

@interface Box : AudioView

-(void)toggleView;

@end
