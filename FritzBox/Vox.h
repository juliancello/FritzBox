//
//  Vox.h
//  FritzBox
//
//  Created by Leif Shackelford on 2/1/18.
//  Copyright © 2018 Leif Shackelford. All rights reserved.
//

#import "AudioView.h"

@interface Vox : AudioView

@property(weak) Deck* deck;

-(void)displayPage:(int) page;

@end
