#import "ShortsOptionsController.h"

@interface ShortsOptionsController ()
- (void)coloursView;
@end

@implementation ShortsOptionsController

- (void)loadView {
	[super loadView];
    [self coloursView];

    self.title = @"Shorts Options";

    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done)];
    self.navigationItem.rightBarButtonItem = doneButton;

    if (@available(iOS 15.0, *)) {
    	[self.tableView setSectionHeaderTopPadding:0.0f];
	}
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"ShortsTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
        cell.textLabel.adjustsFontSizeToFitWidth = YES;
        cell.detailTextLabel.adjustsFontSizeToFitWidth = YES;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (self.traitCollection.userInterfaceStyle == UIUserInterfaceStyleLight) {
            cell.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
            cell.textLabel.textColor = [UIColor blackColor];
            cell.detailTextLabel.textColor = [UIColor blackColor];
        }
        else {
            cell.backgroundColor = [UIColor colorWithRed:0.110 green:0.110 blue:0.118 alpha:1.0];
            cell.textLabel.textColor = [UIColor whiteColor];
            cell.detailTextLabel.textColor = [UIColor whiteColor];
        }
        if (indexPath.row == 0) {
            cell.textLabel.text = @"Hide Like Button";
            UISwitch *hideShortsLikeButton = [[UISwitch alloc] initWithFrame:CGRectZero];
            [hideShortsLikeButton addTarget:self action:@selector(toggleHideShortsLikeButton:) forControlEvents:UIControlEventValueChanged];
            hideShortsLikeButton.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"kHideShortsLikeButton"];
            cell.accessoryView = hideShortsLikeButton;
        }
        if (indexPath.row == 1) {
            cell.textLabel.text = @"Hide Dislike Button";
            UISwitch *hideShortsDislikeButton = [[UISwitch alloc] initWithFrame:CGRectZero];
            [hideShortsDislikeButton addTarget:self action:@selector(toggleHideShortsDislikeButton:) forControlEvents:UIControlEventValueChanged];
            hideShortsDislikeButton.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"kHideShortsDislikeButton"];
            cell.accessoryView = hideShortsDislikeButton;
        }
        if (indexPath.row == 2) {
            cell.textLabel.text = @"Hide Comments Button";
            UISwitch *hideShortsCommentsButton = [[UISwitch alloc] initWithFrame:CGRectZero];
            [hideShortsCommentsButton addTarget:self action:@selector(toggleHideShortsCommentsButton:) forControlEvents:UIControlEventValueChanged];
            hideShortsCommentsButton.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"kHideShortsCommentsButton"];
            cell.accessoryView = hideShortsCommentsButton;
        }
        if (indexPath.row == 3) {
            cell.textLabel.text = @"Hide Remix Button";
            UISwitch *hideShortsRemixButton = [[UISwitch alloc] initWithFrame:CGRectZero];
            [hideShortsRemixButton addTarget:self action:@selector(toggleHideShortsRemixButton:) forControlEvents:UIControlEventValueChanged];
            hideShortsRemixButton.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"kHideShortsRemixButton"];
            cell.accessoryView = hideShortsRemixButton;
        }
        if (indexPath.row == 4) {
            cell.textLabel.text = @"Hide Share Button";
            UISwitch *hideShortsShareButton = [[UISwitch alloc] initWithFrame:CGRectZero];
            [hideShortsShareButton addTarget:self action:@selector(toggleHideShortsShareButton:) forControlEvents:UIControlEventValueChanged];
            hideShortsShareButton.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"kHideShortsShareButton"];
            cell.accessoryView = hideShortsShareButton;
        }
        if (indexPath.row == 5) {
            cell.textLabel.text = @"Hide More Actions Button";
            UISwitch *hideShortsMoreActionsButton = [[UISwitch alloc] initWithFrame:CGRectZero];
            [hideShortsMoreActionsButton addTarget:self action:@selector(toggleHideShortsMoreActionsButton:) forControlEvents:UIControlEventValueChanged];
            hideShortsMoreActionsButton.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"kHideShortsMoreActionsButton"];
            cell.accessoryView = hideShortsMoreActionsButton;
        }
        if (indexPath.row == 6) {
            cell.textLabel.text = @"Hide Subscriptions Button";
            UISwitch *hideShortsSubscriptionsButton = [[UISwitch alloc] initWithFrame:CGRectZero];
            [hideShortsSubscriptionsButton addTarget:self action:@selector(toggleHideShortsSubscriptionsButton:) forControlEvents:UIControlEventValueChanged];
            hideShortsSubscriptionsButton.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"kHideShortsSubscriptionsButton"];
            cell.accessoryView = hideShortsSubscriptionsButton;
        }
    }
    return cell;
}

- (void)coloursView {
    if (self.traitCollection.userInterfaceStyle == UIUserInterfaceStyleLight) {
        self.view.backgroundColor = [UIColor colorWithRed:0.949 green:0.949 blue:0.969 alpha:1.0];
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
        self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    }
    else {
        self.view.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
        self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    }
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [super traitCollectionDidChange:previousTraitCollection];
    [self coloursView];
    [self.tableView reloadData];
}

@end

@implementation ShortsOptionsController (Privates)

- (void)done {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)toggleHideShortsMoreActionsButton:(UISwitch *)sender {
    if ([sender isOn]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"kHideShortsMoreActionsButton"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"kHideShortsMoreActionsButton"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)toggleHideShortsLikeButton:(UISwitch *)sender {
    if ([sender isOn]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"kHideShortsLikeButton"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"kHideShortsLikeButton"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)toggleHideShortsDislikeButton:(UISwitch *)sender {
    if ([sender isOn]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"kHideShortsDislikeButton"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"kHideShortsDislikeButton"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)toggleHideShortsCommentsButton:(UISwitch *)sender {
    if ([sender isOn]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"kHideShortsCommentsButton"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"kHideShortsCommentsButton"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)toggleHideShortsRemixButton:(UISwitch *)sender {
    if ([sender isOn]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"kHideShortsRemixButton"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"kHideShortsRemixButton"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)toggleHideShortsShareButton:(UISwitch *)sender {
    if ([sender isOn]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"kHideShortsShareButton"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"kHideShortsShareButton"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)toggleHideShortsSubscriptionsButton:(UISwitch *)sender {
    if ([sender isOn]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"kHideShortsSubscriptionsButton"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"kHideShortsSubscriptionsButton"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

@end
