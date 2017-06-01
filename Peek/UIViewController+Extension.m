

#import "UIViewController+Extension.h"
#import <objc/runtime.h>


static const void *NavigationBar = &NavigationBar;
static const void *RightBarButton = &RightBarButton;
static const void *TitleLabel = &TitleLabel;
static const void *LeftBarButton = &LeftBarButton;

@interface UIViewController()

@end

@implementation UIViewController(Extension)
@dynamic leftBarButton;
@dynamic rightBarButton;
@dynamic titleLabel;
@dynamic navigationBar;


- (NSString *)navigationBar {
    return objc_getAssociatedObject(self, NavigationBar);
}
- (NSString *)leftBarButton {
    return objc_getAssociatedObject(self, LeftBarButton);
}
- (NSString *)titleLabel {
    return objc_getAssociatedObject(self, TitleLabel);
}
- (NSString *)rightBarButton {
    return objc_getAssociatedObject(self, RightBarButton);
}

- (void)setNavigationBar:(UIView *)navigationBar{
    objc_setAssociatedObject(self, NavigationBar, navigationBar, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (void)setLeftBarButton:(UIView *)leftBarButton{
    objc_setAssociatedObject(self, LeftBarButton, leftBarButton, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (void)setRightBarButton:(UIView *)rightBarButton{
    objc_setAssociatedObject(self, RightBarButton, rightBarButton, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (void)setTitleLabel:(UIView *)titleLabel{
    objc_setAssociatedObject(self, TitleLabel, titleLabel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


-(void)initNavigationBar{
    self.navigationController.navigationBar.hidden = true;
    self.navigationBar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    self.navigationBar.backgroundColor = mainDeepSkyBlue;
    [self.view addSubview:self.navigationBar];
    
    self.leftBarButton = [[UIButton alloc]initWithFrame:CGRectMake(25, 35, 28, 28)];
    [self.leftBarButton setImage:[[UIImage imageNamed:@"back"] imageWithColor:[UIColor whiteColor]] forState:0];
    [self.leftBarButton addTarget:self action:@selector(extentionBack) forControlEvents:1<<6];
    [self.view addSubview:self.leftBarButton];
    
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 32, SCREEN_WIDTH, 20)];
    self.titleLabel.font = [UIFont systemFontOfSize:18];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.view addSubview:self.titleLabel];
    
    self.rightBarButton = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-55, 35, 28, 28)];
    self.rightBarButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.rightBarButton setTitleColor:[UIColor whiteColor] forState:0];
    [self.view addSubview:self.rightBarButton];
}
-(void)extentionBack{
    [self.navigationController popViewControllerAnimated:true];
}
-(void)viewDidDisappear:(BOOL)animated{
    [PJHUD dismiss];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:true];
}
@end
