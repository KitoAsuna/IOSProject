//
//  userInfoViewController.m
//  FOSAapp1.0
//
//  Created by hs on 2020/4/28.
//  Copyright © 2020 hs. All rights reserved.
//

#import "userInfoViewController.h"
#import "takePictureViewController.h"
#import "FosaIMGManager.h"

@interface userInfoViewController ()<UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate,UIImagePickerControllerDelegate>{
    FosaIMGManager *imgManager;
    NSString *currentUser;
}

@end

@implementation userInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self creatUserInfoTable];
}
- (void)creatUserInfoTable{
    self.navigationItem.title = @"Personal Infomation";
    self.view.backgroundColor = FOSAWhite;
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0],NSForegroundColorAttributeName, nil]];
    
    self.userInfoTable = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.navigationController.navigationBar.frame)+Height(10), screen_width, screen_height/4) style:UITableViewStylePlain];
    self.userInfoTable.delegate = self;
    self.userInfoTable.dataSource = self;
    [self.view addSubview:self.userInfoTable];
    
    imgManager = [FosaIMGManager new];
    [imgManager InitImgManager];
    self.headIconView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.userInfoTable.frame.size.height/3, self.userInfoTable.frame.size.height/3)];
    self.headIconView.center = CGPointMake(screen_width-self.userInfoTable.frame.size.height/3, self.userInfoTable.frame.size.height/5);
    currentUser = [[NSUserDefaults standardUserDefaults] valueForKey:@"currentUser"];
    if ([imgManager getImgWithName:currentUser]) {
        self.headIconView.image = [imgManager getImgWithName:currentUser];
    }else{
        self.headIconView.image = [UIImage imageNamed:@"icon_User"];
    }
    self.headIconView.layer.cornerRadius = 10;
    self.headIconView.contentMode = UIViewContentModeScaleAspectFill;
    self.headIconView.clipsToBounds = YES;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return self.userInfoTable.frame.size.height*2/5;
    }else{
        return self.userInfoTable.frame.size.height*3/10;
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"userinfoCell";
       //初始化cell，并指定其类型
    UITableViewCell *cell = [tableView  dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        //创建cell
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"Profile Homepage";
            [cell addSubview:self.headIconView];
            break;
        case 1:
            cell.textLabel.text = @"Username";
            cell.detailTextLabel.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"currentUser"];
            break;
        case 2:
            cell.textLabel.text = @"FOSA ID";
            break;
        default:
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
            [self changeHeaderIcon];
            break;
            
        default:
            break;
    }
}
- (void)changeHeaderIcon{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Set Photo" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *takePhotoAction = [UIAlertAction actionWithTitle:@"Take A Photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"take a photo");
        takePictureViewController *takePhoto = [takePictureViewController new];
        takePhoto.photoBlock = ^(UIImage * _Nonnull img) {
            self.headIconView.image = img;
            [self->imgManager deleteImgWithName:self->currentUser];
            [self->imgManager savePhotoWithImage:img name:self->currentUser];
        };
        [self.navigationController pushViewController:takePhoto animated:NO];
    }];
    UIAlertAction *libraryAction = [UIAlertAction actionWithTitle:@"Choose From Photos" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary; //UIImagePickerControllerSourceTypeSavedPhotosAlbum
        imagePicker.delegate = self;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:takePhotoAction];
    [alert addAction:libraryAction];
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}
#pragma mark - 扫描相册中的二维码-UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    // 对选取照片的处理，如果选取的图片尺寸过大，则压缩选取图片，否则不作处理
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    NSLog(@"%@",image);
    self.headIconView.image = image;
    [self->imgManager deleteImgWithName:currentUser];
    [self->imgManager savePhotoWithImage:image name:currentUser];
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
