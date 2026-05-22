#import "MainAppDelegate.h"
#import <AVFoundation/AVFoundation.h>

@implementation MainAppDelegate

- (instancetype)init
{
    self = [super init];

    if (self) {
        /*
         Create the full-screen animation window. This is a presentation
         overlay only, so it does not need to become a key window or
         participate in window restoration.
         */
        realAnimationWindow =
        [[NSWindow alloc] initWithContentRect:NSZeroRect
                                    styleMask:NSWindowStyleMaskBorderless
                                      backing:NSBackingStoreBuffered
                                        defer:NO];

        [realAnimationWindow setRestorable:NO];
    }

    return self;
}

- (void)setupAnimationWindowWithHidden:(BOOL)hidden
{
    CGFloat alphaValue = hidden ? 0.0 : 1.0;
    NSScreen *screen = [[NSScreen screens] firstObject];

    if (screen == nil) {
        return;
    }

    NSRect screenFrame = [screen frame];

    /*
     Configure the full-screen animation presentation window.
     It is intentionally displayed without becoming the key window.
     */
    [realAnimationWindow setLevel:NSScreenSaverWindowLevel];
    [realAnimationWindow setFrame:screenFrame display:YES];

    /*
     Configure the decorative strip window across the center of the screen.
     */
    [strip setLevel:NSScreenSaverWindowLevel];

    NSRect stripRect = NSMakeRect(0.0,
                                  (NSHeight(screenFrame) / 2.0) - 103.0,
                                  NSWidth(screenFrame),
                                  206.0);

    [strip setFrame:stripRect display:YES];

    /*
     Size the existing AVPlayerView to fill the animation window.
     The XIB already provides this player view, so no separate
     AVPlayerLayer is needed.
     */
    NSRect videoFrame = NSMakeRect(0.0,
                                   0.0,
                                   NSWidth(screenFrame),
                                   NSHeight(screenFrame));

    [stars setFrame:videoFrame];

    [realAnimationWindow orderFront:self];
    [realAnimationWindow setAlphaValue:alphaValue];

    [strip orderWindow:NSWindowAbove
            relativeTo:[realAnimationWindow windowNumber]];
    [strip setAlphaValue:alphaValue];
}

- (IBAction)runEffect:(NSNotification *)notification
{
    if ([_checkbox state] != NSControlStateValueOn) {
        return;
    }

    /*
     Do not start another animation while the current sound is still
     playing or while the previous animation is fading out.
     */
    if ([mySound isPlaying] || timer != nil) {
        return;
    }

    /*
     NSWorkspaceDidLaunchApplicationNotification already contains the
     application that launched. Using it directly avoids rescanning every
     running application and retriggering the effect repeatedly.
     */
    NSRunningApplication *app =
    [[notification userInfo] objectForKey:NSWorkspaceApplicationKey];

    if (app == nil) {
        return;
    }

    NSString *applicationName = [app localizedName];

    if (applicationName != nil) {
        [appName setStringValue:applicationName];
    }

    NSImage *icon = [app icon];

    if (icon != nil) {
        [icon setSize:NSMakeSize(128.0, 128.0)];
        [iconView setImage:icon];
    }

    /*
     Reset the movie before displaying the effect.
     */
    [stars.player pause];

    [stars.player seekToTime:CMTimeMakeWithSeconds(0.0, NSEC_PER_SEC)
              toleranceBefore:kCMTimeZero
               toleranceAfter:kCMTimeZero];

    [self setupAnimationWindowWithHidden:NO];

    [mySound play];
    [stars.player play];
}

- (void)endEffect
{
    if (timer != nil) {
        [timer invalidate];
        timer = nil;
    }

    timer = [NSTimer scheduledTimerWithTimeInterval:0.05
                                             target:self
                                           selector:@selector(fadeEffectOut)
                                           userInfo:nil
                                            repeats:YES];
}

- (void)fadeEffectOut
{
    CGFloat currentAlpha = [realAnimationWindow alphaValue];

    if (currentAlpha > 0.0) {
        CGFloat newAlpha = MAX(0.0, currentAlpha - 0.1);

        [realAnimationWindow setAlphaValue:newAlpha];
        [strip setAlphaValue:newAlpha];
    } else {
        [timer invalidate];
        timer = nil;

        [realAnimationWindow orderOut:self];
        [strip orderOut:self];
    }
}

- (void)sound:(NSSound *)sound didFinishPlaying:(BOOL)finishedPlaying
{
    if (finishedPlaying) {
        [stars.player pause];

        /*
         When the sound finishes, fade the visual effect out.
         */
        [self endEffect];
    }
}

- (void)applicationDidFinishLaunching:(NSNotification *)notification
{
    /*
     These windows are temporary UI and should not be restored by AppKit
     during the next application launch.
     */
    [_window setRestorable:NO];
    [animationWindow setRestorable:NO];
    [strip setRestorable:NO];

    mySound = [NSSound soundNamed:@"effect_sound"];
    [mySound setDelegate:self];

    /*
     Observe applications launched after MegaManEffect has started.
     */
    notCenter = [[NSWorkspace sharedWorkspace] notificationCenter];

    [notCenter addObserver:self
                  selector:@selector(runEffect:)
                      name:NSWorkspaceDidLaunchApplicationNotification
                    object:nil];

    /*
     Move the animation view from its XIB placeholder window into the
     full-screen borderless presentation window.
     */
    NSView *view = [animationWindow contentView];
    [animationWindow setContentView:nil];
    [realAnimationWindow setContentView:view];

    /*
     Create the movie player and attach it directly to the AVPlayerView
     defined in MainMenu.xib.
     */
    NSString *pathToMovie = [[NSBundle mainBundle] pathForResource:@"stars2"
                                                             ofType:@"mov"];

    if (pathToMovie != nil) {
        NSURL *movieURL = [NSURL fileURLWithPath:pathToMovie];

        myMoviePlayer = [[AVPlayer alloc] initWithURL:movieURL];

        [stars setPlayer:myMoviePlayer];
        [stars setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    }

    [strip setAlphaValue:0.0];
    [strip setBackgroundColor:
     [NSColor colorWithPatternImage:[NSImage imageNamed:@"strip.png"]]];

    [_window makeKeyAndOrderFront:self];

    [self setupAnimationWindowWithHidden:YES];
}

- (BOOL)applicationShouldHandleReopen:(NSApplication *)sender
                    hasVisibleWindows:(BOOL)flag
{
    [_window makeKeyAndOrderFront:self];

    return YES;
}

- (BOOL)applicationSupportsSecureRestorableState:(NSApplication *)app
{
    return YES;
}

- (void)applicationWillTerminate:(NSNotification *)notification
{
    [notCenter removeObserver:self];

    if (timer != nil) {
        [timer invalidate];
        timer = nil;
    }

    [stars.player pause];
}

@end
