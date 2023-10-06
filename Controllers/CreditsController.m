#import "CreditsController.h"

@interface CreditsController ()
- (void)coloursView;
@end

@implementation CreditsController

- (void)loadView {
	[super loadView];
    [self coloursView];

    self.title = @"Credits";

    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done)];
    self.navigationItem.rightBarButtonItem = doneButton;

    if (@available(iOS 15.0, *)) {
    	[self.tableView setSectionHeaderTopPadding:0.0f];
	}
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    if (section == 1) {
        return 4;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"CreditsTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
        cell.textLabel.adjustsFontSizeToFitWidth = YES;
        cell.detailTextLabel.adjustsFontSizeToFitWidth = YES;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
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
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                cell.textLabel.text = @"Lillie";
                cell.detailTextLabel.text = @"Developer";
            }
        }
        if (indexPath.section == 1) {
            if (indexPath.row == 0) {
                cell.textLabel.text = @"Alpha_Stream";
                cell.detailTextLabel.text = @"Icon Designer";
            }
            if (indexPath.row == 1) {
                cell.textLabel.text = @"kirb";
                cell.detailTextLabel.text = @"Development Support";
            }
            if (indexPath.row == 2) {
                cell.textLabel.text = @"PoomSmart";
                cell.detailTextLabel.text = @"Features: \"Adblock\", \"AutoPlay In Fullscreen\"";
            }
            if (indexPath.row == 3) {
                cell.textLabel.text = @"Snoolie";
                cell.detailTextLabel.text = @"Features: \"Enable Extra Video Speed\"";
            }
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)theTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [theTableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://github.com/LillieH1000"] options:@{} completionHandler:nil];
        }
    }
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://twitter.com/Kutarin_"] options:@{} completionHandler:nil];
        }
        if (indexPath.row == 1) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://github.com/kirb"] options:@{} completionHandler:nil];
        }
        if (indexPath.row == 2) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://twitter.com/PoomSmart"] options:@{} completionHandler:nil];
        }
        if (indexPath.row == 3) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://github.com/0xilis"] options:@{} completionHandler:nil];
        }
    }
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

@implementation CreditsController (Privates)

- (void)done {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

@end