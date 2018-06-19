#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "FlatUIKit.h"
#import "FUIAlertView.h"
#import "FUIButton.h"
#import "FUICellBackgroundView.h"
#import "FUIPopoverBackgroundView.h"
#import "FUISegmentedControl.h"
#import "FUISwitch.h"
#import "FUITextField.h"
#import "NSString+Icons.h"
#import "UIBarButtonItem+FlatUI.h"
#import "UIColor+FlatUI.h"
#import "UIFont+FlatUI.h"
#import "UIImage+FlatUI.h"
#import "UINavigationBar+FlatUI.h"
#import "UIPopoverController+FlatUI.h"
#import "UIProgressView+FlatUI.h"
#import "UISlider+FlatUI.h"
#import "UIStepper+FlatUI.h"
#import "UITabBar+FlatUI.h"
#import "UITableViewCell+FlatUI.h"
#import "UIToolbar+FlatUI.h"

FOUNDATION_EXPORT double FlatUIKitVersionNumber;
FOUNDATION_EXPORT const unsigned char FlatUIKitVersionString[];

