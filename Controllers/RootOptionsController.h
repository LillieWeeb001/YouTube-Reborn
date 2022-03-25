#import <UIKit/UIKit.h>

@interface RootOptionsController : UITableViewController

@end

@interface UIView ()
- (UIViewController*)_viewControllerForAncestor;
@end

@interface UITableViewCellWithColorWell : UITableViewCell <UIColorPickerViewControllerDelegate>
@property (strong, nonatomic) UIColorWell *colorWell;
#ifdef __IPHONE_15_0
- (void)colorPickerViewController:(UIColorPickerViewController*)viewController 
                   didSelectColor:(UIColor*)color;
                     continuously:(BOOL)continuously;
#else
- (void)colorPickerViewControllerDidSelectColor:(UIColorPickerViewController*)viewController;
#endif
- (void)presentColorPicker:(UITableViewCell*)sender;
@end
