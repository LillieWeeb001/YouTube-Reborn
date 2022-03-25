#import "RebornSettingsController.h"
#import "../iOS15Fix.h"

static int __isOSVersionAtLeast(int major, int minor, int patch) { NSOperatingSystemVersion version; version.majorVersion = major; version.minorVersion = minor; version.patchVersion = patch; return [[NSProcessInfo processInfo] isOperatingSystemAtLeastVersion:version]; }

@interface RebornSettingsController ()
@end

@implementation RebornSettingsController

- (void)loadView {
	[super loadView];

    self.title = @"Reborn Options";
    if (self.traitCollection.userInterfaceStyle == UIUserInterfaceStyleLight) {
        self.view.backgroundColor = [UIColor colorWithRed:0.949 green:0.949 blue:0.969 alpha:1.0];
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
    }
    else {
        self.view.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
        self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    }

    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done)];
    self.navigationItem.rightBarButtonItem = doneButton;

    if (@available(iOS 15.0, *)) {
    	[self.tableView setSectionHeaderTopPadding:0.0f];
	}
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)theTableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)theTableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    if (section == 1) {
        return 1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"TabBarTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
        cell.textLabel.adjustsFontSizeToFitWidth = true;
        if (self.traitCollection.userInterfaceStyle == UIUserInterfaceStyleLight) {
            cell.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
            cell.textLabel.textColor = [UIColor blackColor];
        }
        else {
            cell.backgroundColor = [UIColor colorWithRed:0.110 green:0.110 blue:0.118 alpha:1.0];
            cell.textLabel.textColor = [UIColor whiteColor];
        }
        if(indexPath.section == 0) {
            if(indexPath.row == 0) {
                cell.textLabel.text = @"Reset Colour Options";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
        }
        if(indexPath.section == 1) {
            if(indexPath.row == 0) {
                cell.textLabel.text = @"Hide Overlay 'OP' Button";
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                UISwitch *hideRebornOPButton = [[UISwitch alloc] initWithFrame:CGRectZero];
                [hideRebornOPButton addTarget:self action:@selector(toggleHideRebornOPButton:) forControlEvents:UIControlEventValueChanged];
                hideRebornOPButton.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"kHideRebornOPButtonVTwo"];
                cell.accessoryView = hideRebornOPButton;
            }
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)theTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [theTableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.section == 0) {
        if(indexPath.row == 0) {
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"kYTRebornColourOptionsVTwo"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [[UIApplication sharedApplication] suspend];
            [NSThread sleepForTimeInterval:0.7];
            exit(0);
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return 50;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {        
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 1) {
        return 10;
    }
    return 0;
}

@end

@implementation RebornSettingsController(Privates)

- (void)done {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)toggleHideRebornOPButton:(UISwitch *)sender {
    if ([sender isOn]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"kHideRebornOPButtonVTwo"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"kHideRebornOPButtonVTwo"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

@end
