//
//  UKBorderlessWindow.m
//  Filie
//
//  Created by Uli Kusterer on Fri Dec 19 2003.
//  Copyright (c) 2003 M. Uli Kusterer. All rights reserved.
//

#import "UKBorderlessWindow.h"


@implementation UKBorderlessWindow

// Designated initializer:
- (instancetype)initWithContentRect:(NSRect)box
                           styleMask:(NSWindowStyleMask)styleMask
                             backing:(NSBackingStoreType)backingType
                               defer:(BOOL)flag
{
    /*
     UKBorderlessWindow is always intentionally borderless, regardless
     of the style mask supplied by older callers or Interface Builder.
     */
    self = [super initWithContentRect:box
                            styleMask:NSWindowStyleMaskBorderless
                              backing:backingType
                                defer:flag];

    if (self != nil) {
        constrainRect = NO;
    }

    return self;
}


// Convenience initializer:
- (instancetype)initWithContentRect:(NSRect)box
                             backing:(NSBackingStoreType)backingType
                               defer:(BOOL)flag
{
    return [self initWithContentRect:box
                           styleMask:NSWindowStyleMaskBorderless
                             backing:backingType
                               defer:flag];
}


// Borderless windows normally cannot become key windows.
// This historical subclass allows it when needed.
- (BOOL)canBecomeKeyWindow
{
    return YES;
}


// Allow this borderless window to cover the menu bar unless constrained.
- (NSRect)constrainFrameRect:(NSRect)frameRect
                    toScreen:(NSScreen *)screen
{
    if (!constrainRect) {
        return frameRect;
    }

    return [super constrainFrameRect:frameRect toScreen:screen];
}


- (BOOL)constrainRect
{
    return constrainRect;
}


- (void)setConstrainRect:(BOOL)newConstrainRect
{
    constrainRect = newConstrainRect;
}

@end
