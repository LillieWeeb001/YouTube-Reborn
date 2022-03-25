#import "TabBarOptionsController.h"
#import "StartupPageOptionsController.h"
#import "../iOS15Fix.h"

static int __isOSVersionAtLeast(int major, int minor, int patch) { NSOperatingSystemVersion version; version.majorVersion = major; version.minorVersion = minor; version.patchVersion = patch; return [[NSProcessInfo processInfo] isOperatingSystemAtLeastVersion:version]; }

@interface TabBarOptionsController ()
@end

@implementation TabBarOptionsController

- (void)loadView {
	[super loadView];

    self.title = @"TabBar Options";
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
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"kHideTabBar"]) {
        return 3;
    } else {
        return 2;
    }
}

- (NSInteger)tableView:(UITableView *)theTableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    if (section == 1) {
        return 1;
    }
    if (section == 2) {
        return [[NSUserDefaults standardUserDefaults] boolForKey:@"kHideTabBar"] ? 0 : 5;
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
            cell.textLabel.text = @"Startup Page";
            if ([[NSUserDefaults standardUserDefaults] integerForKey:@"kStartupPageInt"] == nil) {
                cell.detailTextLabel.text = @"Home";
            } else {
                int selectedTab = [[NSUserDefaults standardUserDefaults] integerForKey:@"kStartupPageInt"];
                if (selectedTab == 0) {
                    cell.detailTextLabel.text = @"Home";
                }
                if (selectedTab == 1) {
                    cell.detailTextLabel.text = @"Explore";
                }
                if (selectedTab == 2) {
                    cell.detailTextLabel.text = @"Shorts";
                }
                if (selectedTab == 3) {
                    cell.detailTextLabel.text = @"Create/Upload (+)";
                }
                if (selectedTab == 4) {
                    cell.detailTextLabel.text = @"Subscriptions";
                }
                if (selectedTab == 5) {
                    cell.detailTextLabel.text = @"Library";
                }
                if (selectedTab == 6) {
                    cell.detailTextLabel.text = @"Trending";
                }
            }
        }
        if(indexPath.section == 1) {
            if(indexPath.row == 0) {
                cell.textLabel.text = @"Hide Tab Bar";
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                UISwitch *hideTabBar = [[UISwitch alloc] initWithFrame:CGRectZero];
                [hideTabBar addTarget:self action:@selector(toggleHideTabBar:) forControlEvents:UIControlEventValueChanged];
                hideTabBar.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"kHideTabBar"];
                cell.accessoryView = hideTabBar;
            }
        }
        if(indexPath.section == 2) {
            if(indexPath.row == 0) {
                cell.textLabel.text = @"Hide Tab Bar Labels";
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                UISwitch *hideTabBarLabels = [[UISwitch alloc] initWithFrame:CGRectZero];
                [hideTabBarLabels addTarget:self action:@selector(toggleHideTabBarLabels:) forControlEvents:UIControlEventValueChanged];
                hideTabBarLabels.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"kHideTabBarLabels"];
                cell.accessoryView = hideTabBarLabels;
            }
            if(indexPath.row == 1) {
                cell.textLabel.text = @"Hide Shorts/Explore Tab";
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                UISwitch *hideExploreTab = [[UISwitch alloc] initWithFrame:CGRectZero];
                [hideExploreTab addTarget:self action:@selector(toggleHideExploreTab:) forControlEvents:UIControlEventValueChanged];
                hideExploreTab.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"kHideExploreTab"];
                cell.accessoryView = hideExploreTab;
            }
            if(indexPath.row == 2) {
                cell.textLabel.text = @"Hide Create/Upload (+) Tab";
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                UISwitch *hideUploadTab = [[UISwitch alloc] initWithFrame:CGRectZero];
                [hideUploadTab addTarget:self action:@selector(toggleHideUploadTab:) forControlEvents:UIControlEventValueChanged];
                hideUploadTab.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"kHideUploadTab"];
                cell.accessoryView = hideUploadTab;
            }
            if(indexPath.row == 3) {
                cell.textLabel.text = @"Hide Subscriptions Tab";
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                UISwitch *hideSubscriptionsTab = [[UISwitch alloc] initWithFrame:CGRectZero];
                [hideSubscriptionsTab addTarget:self action:@selector(toggleHideSubscriptionsTab:) forControlEvents:UIControlEventValueChanged];
                hideSubscriptionsTab.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"kHideSubscriptionsTab"];
                cell.accessoryView = hideSubscriptionsTab;
            }
            if(indexPath.row == 4) {
                cell.textLabel.text = @"Hide Library Tab";
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                UISwitch *hideLibraryTab = [[UISwitch alloc] initWithFrame:CGRectZero];
                [hideLibraryTab addTarget:self action:@selector(toggleHideLibraryTab:) forControlEvents:UIControlEventValueChanged];
                hideLibraryTab.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"kHideLibraryTab"];
                cell.accessoryView = hideLibraryTab;
            }
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)theTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [theTableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.section == 0) {
        if(indexPath.row == 0) {
            StartupPageOptionsController *startupPageOptionsController = [[StartupPageOptionsController alloc] init];
            UINavigationController *startupPageOptionsControllerView = [[UINavigationController alloc] initWithRootViewController:startupPageOptionsController];
            startupPageOptionsControllerView.modalPresentationStyle = UIModalPresentationFullScreen;

            [self presentViewController:startupPageOptionsControllerView animated:YES completion:nil];
        }
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [self.tableView reloadData];
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
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"kHideTabBar"]) {
        if(section == 2) {
            return 10;
        }
    } else {
        if(section == 1) {
            return 10;
        }
    }
    return 0;
}

@end

@implementation TabBarOptionsController(Privates)

- (void)done {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)toggleHideTabBar:(UISwitch *)sender {
    NSMutableArray* indexPaths = [NSMutableArray array];
    for (int i = 0; i < 5; i++) {
        [indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:2]];
    }
    [self.tableView beginUpdates];
    if ([sender isOn]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"kHideTabBar"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
    } else {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"kHideTabBar"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
    }
    [self.tableView endUpdates];
}

- (void)toggleHideTabBarLabels:(UISwitch *)sender {
    if ([sender isOn]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"kHideTabBarLabels"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"kHideTabBarLabels"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)toggleHideExploreTab:(UISwitch *)sender {
    if ([sender isOn]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"kHideExploreTab"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"kHideExploreTab"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)toggleHideUploadTab:(UISwitch *)sender {
    if ([sender isOn]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"kHideUploadTab"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"kHideUploadTab"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)toggleHideSubscriptionsTab:(UISwitch *)sender {
    if ([sender isOn]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"kHideSubscriptionsTab"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"kHideSubscriptionsTab"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)toggleHideLibraryTab:(UISwitch *)sender {
    if ([sender isOn]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"kHideLibraryTab"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"kHideLibraryTab"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

@end
