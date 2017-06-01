

#import <UIKit/UIKit.h>

@interface UIViewController(Extension)

@property (nonatomic, strong) UIView *navigationBar;

@property (nonatomic, strong) UIButton *leftBarButton;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIButton *rightBarButton;


-(void)initNavigationBar;

@end
