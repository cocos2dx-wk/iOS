//
//  QYSetContactInfoVC.m
//  QYStaging
//
//  Created by Jyawei on 2017/7/27.
//  Copyright © 2017年 wangkai. All rights reserved.
//

#import "QYSetContactInfoVC.h"
#import <Contacts/Contacts.h>
#import <ContactsUI/ContactsUI.h>

#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

#define IOS8_ABOVE IOS_VERSION >= 9.0


@interface QYSetContactInfoVC ()<UITextFieldDelegate,UIActionSheetDelegate,CNContactPickerDelegate,ABPeoplePickerNavigationControllerDelegate>

/** 关系 */
@property (weak, nonatomic) IBOutlet UILabel *relationLable;
/** 姓名 */
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
/** 电话 */
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
/** 保存按钮 */
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
/** 背景高度 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewHeight;


@end

@implementation QYSetContactInfoVC

+ (instancetype)vc {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"QYHomePage" bundle:nil];
    return [sb instantiateViewControllerWithIdentifier:NSStringFromClass(self)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (iphone6Plus) {
        self.viewHeight.constant = 736-44;
    } else if (iphone6) {
        self.viewHeight.constant = 667-64;
    } else if (iphone5) {
        self.viewHeight.constant = 568-64;
    } else {
        self.viewHeight.constant = 568;
    }
    
    [self.saveBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithMacHexString:@"#575DFE"]] forState:UIControlStateNormal];
    [self.saveBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithMacHexString:@"#CCCCCC"]] forState:UIControlStateDisabled];
    
    self.nameTextField.delegate = self;
    self.phoneTextField.delegate = self;
    
    [self registerOrNotication];
    
    [self setContactInfo:_contactInfo];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
    [self checkSaveBtnStatus];
    [self setRelationLableColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - 赋值
- (void)setContacts:(NSMutableArray *)contacts {
    _contacts = contacts;
}

- (void)setIndex:(NSInteger)index {
    _index = index;
}

#pragma mark - 注册及通知的实现
- (void)registerOrNotication {
    
    [self.nameTextField addTarget:self action:@selector(textFieldWithText:) forControlEvents:UIControlEventEditingChanged];
    [self.phoneTextField addTarget:self action:@selector(textFieldWithText:) forControlEvents:UIControlEventEditingChanged];
}

- (void)textFieldWithText:(UITextField *)textField {
    [self checkSaveBtnStatus];
}

#pragma mark - 私有方法
/**
 判断提交按钮状态
 */
- (void)checkSaveBtnStatus {
    
    if (self.phoneTextField.text.length > 0 && self.nameTextField.text.length > 0 && ![self.relationLable.text isEqualToString:@"请选择"]) {
        self.saveBtn.enabled = YES;
    } else {
        self.saveBtn.enabled = NO;
    }
}

/**
 设置关系内容文字颜色
 */
- (void)setRelationLableColor {
    if ([self.relationLable.text isEqualToString:@"请选择"]) {
        self.relationLable.textColor = [UIColor colorWithHexString:@"AAAEB5"];
    } else {
        self.relationLable.textColor = [UIColor colorWithHexString:@"4C4C4C"];
    }
}

/**
 添加对应的title 这个方法也可以传进一个数组的titles 我只传一个是为了方便实现每个title的对应的响应事件不同的需求不同的方法
 */
- (void)addActionTarget:(UIAlertController *)alertController title:(NSString *)title color:(UIColor *)color action:(void(^)(UIAlertAction *action))actionTarget {
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        actionTarget(action);
    }];
    
    if (self.relationLable.text.length > 0) {
        if ([self.relationLable.text isEqualToString:title]) {
            color = [UIColor colorWithHexString:@"FE6B6B"];
        }
    }
    
    if (IOS_VERSION >= 9.0) {
        [action setValue:color forKey:@"_titleTextColor"];
    }
    
    [alertController addAction:action];
}

/**
 取消按钮
 */
- (void)addCancelActionTarget:(UIAlertController*)alertController title:(NSString *)title {
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }];
    if (IOS_VERSION >= 9.0) {
        [action setValue:[UIColor colorWithHexString:@"575DFE"] forKey:@"_titleTextColor"];
    }
    
    [alertController addAction:action];
}

/**
 校验联系人信息
 */
- (void)checkContactInfo {
    if(self.phoneTextField.text.length <= 0){
        [self showMessageWithString:@"请输入手机号"];
        return;
    }
    
    if(self.nameTextField.text.length <= 0 || self.nameTextField.text.length > 16 ){
        [self showMessageWithString:@"请输入正确姓名"];
        return;
    }
    if([self.nameTextField.text isContainsEmoji]  ){
        [self showMessageWithString:@"请输入正确姓名"];
        return;
    }
    if(![self.nameTextField.text checkingChineseName]  ){
        [self showMessageWithString:@"请输入正确姓名"];
        return;
    }
    
    
    if ([self.relationLable.text isEqualToString:@"请选择"]) {
        [self showMessageWithString:@"请选择联系人关系"];
        return;
    }
    
    NSString *contactIceName = nil;
    if ([self.nameTextField.text rangeOfString:@"*"].location != NSNotFound) {
        contactIceName = [self queryInfo].emergencyContact.iceName;
    } else {
        contactIceName = self.nameTextField.text;
    }
    
    if(![contactIceName checkingChineseName]){
        [self showMessageWithString:@"姓名格式错误"];
        return;
    }
    
    NSString *contactIcePhone = nil;
    if ([self.phoneTextField.text rangeOfString:@"****"].location != NSNotFound) {
        contactIcePhone = [self queryInfo].emergencyContact.icePhone;
    } else {
        contactIcePhone = self.phoneTextField.text;
    }
    
//    if (![contactIcePhone checkMobileNumber]) {
//        [self showMessageWithString:@"电话格式错误，请输入正确的电话号码"];
//        return;
//    }
    
    if ([self.phoneTextField.text isEqualToString:[self queryInfo].phoneNum]) {
        [self showMessageWithString:@"常用联系人请勿添加自己"];
        return;
    }
    
    __block BOOL exist = NO;
    [self.contacts enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSDictionary *dict = obj;
        NSString *phoneStr = dict[@"phone"];
        NSString *nameStr = dict[@"name"];
        if (!self.contactInfo) {
            if ([self.phoneTextField.text isEqualToString:phoneStr] || [self.nameTextField.text isEqualToString:nameStr]) {
                *stop = YES;
                exist = YES;
            }
        } else {
            if (_index != idx) {
                if ([self.phoneTextField.text isEqualToString:phoneStr] || [self.nameTextField.text isEqualToString:nameStr]) {
                    *stop = YES;
                    exist = YES;
                }
            }
        }
    }];

    if (exist) {
        [self showMessageWithString:@"请勿重复添加常用联系人"];
        return;
    }
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    dict[@"relation"] = self.relationLable.text;
    dict[@"name"] = self.nameTextField.text;
    dict[@"phone"] = self.phoneTextField.text;
    
    if (self.contactInfo) {
        self.changeContactsBlock(dict);
    } else {
        self.addContactsBlock(dict);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 联系人回显
 */
- (void)setContactInfo:(NSMutableDictionary *)contactInfo {
    
    if (contactInfo) {
        _contactInfo = contactInfo;
        self.relationLable.text = contactInfo[@"relation"];
        self.nameTextField.text = contactInfo[@"name"];
        self.phoneTextField.text = contactInfo[@"phone"];
    }
}

#pragma mark - 按钮活动
/**
 点击选择关系
 */
- (IBAction)changeRelationBtnClicked:(UIButton *)sender {
    sender.enabled = NO;
    [self.view endEditing:YES];
    
    if (IOS_VERSION > 8) {
        __weak typeof (self) weakSelf = self;
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        [self addActionTarget:alert title:@"配偶" color: [UIColor colorWithHexString:@"4C4C4C"] action:^(UIAlertAction *action) {
            weakSelf.relationLable.text = @"配偶";
            [weakSelf checkSaveBtnStatus];
            [weakSelf setRelationLableColor];
        }];
        [self addActionTarget:alert title:@"父母" color: [UIColor colorWithHexString:@"4C4C4C"] action:^(UIAlertAction *action) {
            weakSelf.relationLable.text = @"父母";
            [weakSelf checkSaveBtnStatus];
            [weakSelf setRelationLableColor];
        }];
        
        [self addActionTarget:alert title:@"子女" color: [UIColor colorWithHexString:@"4C4C4C"] action:^(UIAlertAction *action) {
            weakSelf.relationLable.text = @"子女";
            [weakSelf checkSaveBtnStatus];
            [weakSelf setRelationLableColor];
        }];
        
        [self addActionTarget:alert title:@"其它" color: [UIColor colorWithHexString:@"4C4C4C"] action:^(UIAlertAction *action) {
            weakSelf.relationLable.text = @"其它";
            [weakSelf checkSaveBtnStatus];
            [weakSelf setRelationLableColor];
        }];
        
        [self addCancelActionTarget:alert title:@"取消"];
        [self presentViewController:alert animated:YES completion:nil];
    }else{
        UIActionSheet *marriageActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"配偶", @"父母",@"子女",@"其它", nil];
        [marriageActionSheet showInView:self.view];
    }
    
    sender.enabled = YES;
}

/**
 点击进入通讯录
 */
- (IBAction)enterAddressBookBtnClicked:(UIButton *)sender {
    sender.enabled = NO;
    [self.view endEditing:YES];
    
    [AppGlobal checkAddressBookAuthorization:^(bool isAuthorized, bool ios8_above) {
        if (isAuthorized) {
            [self callAddressBook:ios8_above];
            
            if ([self.isHaveMailList isEqualToString:@"0"]) {
                NSArray *books = [[NSUserDefaults standardUserDefaults] objectForKey:@"books"];
                if (!books || books.count <= 0) {
                    [self getAddressBooks:ios8_above];
                }
            }
        } else {
            [self addressBookAlert];
        }
    }];
    
    sender.enabled = YES;
}

/**
 点击保存
 */
- (IBAction)saveBtnClicked:(UIButton *)sender {
    sender.enabled = NO;
    
    [self.view endEditing:YES];
    [self checkContactInfo];
    
    sender.enabled = YES;
}

/**
 打开通讯录
 */
- (void)callAddressBook:(BOOL)ios8_above {
    
    if (ios8_above) {
        CNContactPickerViewController *contactPicker = [[CNContactPickerViewController alloc] init];
        contactPicker.delegate = self;
        [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
        contactPicker.predicateForSelectionOfContact = [NSPredicate predicateWithValue:false];
        [self presentViewController:contactPicker animated:YES completion:nil];
    } else {
        ABPeoplePickerNavigationController *peoplePicker = [[ABPeoplePickerNavigationController alloc] init];
        peoplePicker.peoplePickerDelegate = self;
        [peoplePicker setHidesBottomBarWhenPushed:YES];
        [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
        peoplePicker.predicateForSelectionOfPerson = [NSPredicate predicateWithValue:false];
        [self presentViewController:peoplePicker animated:YES completion:nil];
    }
}

/**
 授权提示
 */
- (void)addressBookAlert {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请去设置中允许轻易分期访问您的通讯录" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
    }];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}

/**
 获取用户通讯录
 */
- (void)getAddressBooks:(BOOL)IOS8_above {
    
    if (IOS8_above) {//ios9以上
        ABAddressBookRef addBook = nil;
        
        //创建通讯簿的引用
        addBook = ABAddressBookCreateWithOptions(NULL, NULL);
        NSMutableArray *mailList = [NSMutableArray array];
        
        NSArray *keysToFetch = @[CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey,CNContactNoteKey];
        CNContactFetchRequest *fetchRequest = [[CNContactFetchRequest alloc] initWithKeysToFetch:keysToFetch];
        CNContactStore *contactStore = [[CNContactStore alloc] init];
        
        [contactStore enumerateContactsWithFetchRequest:fetchRequest error:nil usingBlock:^(CNContact * _Nonnull contact, BOOL * _Nonnull stop) {
            
            NSString *name = [NSString stringWithFormat:@"%@%@",contact.familyName,contact.givenName];
            NSString *nameStr = name ? name : @"";
            NSString *note = contact.note ? contact.note : @"";
            
            NSArray *phoneNumbers = contact.phoneNumbers;
            NSString *phone = @"";
            if (phoneNumbers.count > 0) {
                for (int i = 0; i < phoneNumbers.count; i++) {
                    CNLabeledValue *labelValue = [phoneNumbers objectAtIndex:i];
                    CNPhoneNumber *phoneNumber = labelValue.value;
                    phone = phoneNumber.stringValue ? phoneNumber.stringValue : @"";
                    NSMutableDictionary *personDict = [[NSMutableDictionary alloc] init];
                    [personDict setObject:phone forKey:@"phone"];
                    [personDict setObject:nameStr forKey:@"userName"];
                    [personDict setObject:note forKey:@"remarks"];
                    [personDict setObject:@"" forKey:@"groupName"];
                    [mailList addObject:personDict];
                }
            } else {
                NSMutableDictionary *personDict = [[NSMutableDictionary alloc] init];
                [personDict setObject:phone forKey:@"phone"];
                [personDict setObject:nameStr forKey:@"userName"];
                [personDict setObject:note forKey:@"remarks"];
                [personDict setObject:@"" forKey:@"groupName"];
                [mailList addObject:personDict];
            }
        }];
        if (mailList.count > 0) {
            [[NSUserDefaults standardUserDefaults] setObject:mailList forKey:@"books"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        
    } else {//ios9以下
        ABAddressBookRef addressBookRef = ABAddressBookCreate();
        CFArrayRef arrayRef = ABAddressBookCopyArrayOfAllPeople(addressBookRef);
        long count = CFArrayGetCount(arrayRef);
        NSMutableArray *mailList = [NSMutableArray array];
        
        for (int i = 0; i < count; i++) {
            
            //获取联系人对象的引用
            ABRecordRef people = CFArrayGetValueAtIndex(arrayRef, i);
            //获取当前联系人名字
            NSString *firstName=(__bridge NSString *)(ABRecordCopyValue(people, kABPersonFirstNameProperty));
            NSString *lastName=(__bridge NSString *)(ABRecordCopyValue(people, kABPersonLastNameProperty));
            NSString *name = [NSString stringWithFormat:@"%@%@",lastName,firstName];
            NSString *nameStr = name ? name : @"";
            //获取当前联系人的备注
            NSString *remark = (__bridge NSString*)(ABRecordCopyValue(people, kABPersonNoteProperty));
            NSString *remarks = remark ? remark : @"";
            
            //获取当前联系人的电话
            ABMultiValueRef phones = ABRecordCopyValue(people, kABPersonPhoneProperty);
            NSString *phone = @"";
            if (ABMultiValueGetCount(phones) > 0) {
                
                for (int i = 0; i < ABMultiValueGetCount(phones); i++) {
                    phone = (__bridge NSString *)(ABMultiValueCopyValueAtIndex(phones,i));
                    NSMutableDictionary *personDict = [[NSMutableDictionary alloc] init];
                    [personDict setObject:nameStr forKey:@"userName"];
                    [personDict setObject:remarks forKey:@"remarks"];
                    [personDict setObject:phone forKey:@"phone"];
                    [personDict setObject:@"" forKey:@"groupName"];
                    [mailList addObject:personDict];
                }
            } else {
                NSMutableDictionary *personDict = [[NSMutableDictionary alloc] init];
                [personDict setObject:nameStr forKey:@"userName"];
                [personDict setObject:remarks forKey:@"remarks"];
                [personDict setObject:phone forKey:@"phone"];
                [personDict setObject:@"" forKey:@"groupName"];
                [mailList addObject:personDict];
            }
        }
        if (mailList.count > 0) {
            [[NSUserDefaults standardUserDefaults] setObject:mailList forKey:@"books"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if([string length] != 0) {
        // 点击了非删除键
    } else {
        return YES;// 删除键
    }
    
    // 不能输入空格
    NSString *str = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([str length] == 0) {
        [self showMessageWithString:@"不能输入空格"];
        return NO;
    }
    
    if (textField == self.phoneTextField) {
        //手机号必须是数字
        if (![string isvalidDigits]) {
            [self showMessageWithString:@"手机号必须是数字"];
            return NO;
        }
        
        //手机号小于11位
        if (textField.text.length >= 11) {
            return NO;
        }
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.view endEditing:YES];
    return YES;
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0) {
        self.relationLable.text = @"配偶";
    }else if (buttonIndex == 1){
        self.relationLable.text = @"父母";
    }
    else if (buttonIndex == 2){
        self.relationLable.text = @"子女";
    }
    else if (buttonIndex == 3){
        self.relationLable.text = @"其它";
    }
    
    [self checkSaveBtnStatus];
    [self setRelationLableColor];
}

#pragma mark - CNContactPickerDelegate
- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContactProperty:(CNContactProperty *)contactProperty {
    
    CNPhoneNumber *phoneNumber = (CNPhoneNumber *)contactProperty.value;
    
    // 联系人
    NSString *nameStr = [NSString stringWithFormat:@"%@%@",contactProperty.contact.familyName,contactProperty.contact.givenName];
    self.nameTextField.text = nameStr;
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    //电话
    NSString *newPhone1 = [NSString stringWithFormat:@"%@",phoneNumber.stringValue];
    NSString *newPhone = newPhone1;
    if ([newPhone containsString:@"-"]) {
        newPhone = [newPhone stringByReplacingOccurrencesOfString:@"-" withString:@""];
    }
    if ([newPhone containsString:@"("]) {
        newPhone = [newPhone stringByReplacingOccurrencesOfString:@"(" withString:@""];
    }
    if ([newPhone containsString:@")"]) {
        newPhone = [newPhone stringByReplacingOccurrencesOfString:@")" withString:@""];
    }
    if ([newPhone containsString:@" "]) {
        newPhone = [newPhone stringByReplacingOccurrencesOfString:@" " withString:@""];
    }
    self.phoneTextField.text = newPhone;
}

#pragma mark - ABPeoplePickerNavigationControllerDelegate
- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker didSelectPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier {
    
    ABMultiValueRef phone = ABRecordCopyValue(person, kABPersonPhoneProperty);
    
    //姓名
    NSString *firstName = (__bridge NSString *)ABRecordCopyValue(person, kABPersonFirstNameProperty);
    NSString *lastName = (__bridge NSString *)ABRecordCopyValue(person, kABPersonLastNameProperty);
    self.nameTextField.text = [NSString stringWithFormat:@"%@%@",lastName ? lastName :@"",firstName?firstName:@""];
    
    //电话
    long index = ABMultiValueGetIndexForIdentifier(phone,identifier);
    NSString *phoneNO = @"";
    if (index >= 0) {
        phoneNO = (__bridge NSString *)ABMultiValueCopyValueAtIndex(phone, index);
        if ([phoneNO containsString:@"-"]) {
            phoneNO = [phoneNO stringByReplacingOccurrencesOfString:@"-" withString:@""];
        }
    }
    self.phoneTextField.text = [AppGlobal repleaceBlankWithString:phoneNO];
}


@end
