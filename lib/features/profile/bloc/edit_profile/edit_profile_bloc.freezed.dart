// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'edit_profile_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$EditProfileEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EditProfileEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'EditProfileEvent()';
}


}

/// @nodoc
class $EditProfileEventCopyWith<$Res>  {
$EditProfileEventCopyWith(EditProfileEvent _, $Res Function(EditProfileEvent) __);
}


/// Adds pattern-matching-related methods to [EditProfileEvent].
extension EditProfileEventPatterns on EditProfileEvent {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Initialize value)?  initialize,TResult Function( _LocalImageChanged value)?  localImageChanged,TResult Function( _SaveProfile value)?  saveProfile,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Initialize() when initialize != null:
return initialize(_that);case _LocalImageChanged() when localImageChanged != null:
return localImageChanged(_that);case _SaveProfile() when saveProfile != null:
return saveProfile(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Initialize value)  initialize,required TResult Function( _LocalImageChanged value)  localImageChanged,required TResult Function( _SaveProfile value)  saveProfile,}){
final _that = this;
switch (_that) {
case _Initialize():
return initialize(_that);case _LocalImageChanged():
return localImageChanged(_that);case _SaveProfile():
return saveProfile(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Initialize value)?  initialize,TResult? Function( _LocalImageChanged value)?  localImageChanged,TResult? Function( _SaveProfile value)?  saveProfile,}){
final _that = this;
switch (_that) {
case _Initialize() when initialize != null:
return initialize(_that);case _LocalImageChanged() when localImageChanged != null:
return localImageChanged(_that);case _SaveProfile() when saveProfile != null:
return saveProfile(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( UserModel user)?  initialize,TResult Function( File imageFile)?  localImageChanged,TResult Function( String name,  String email,  String phone)?  saveProfile,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Initialize() when initialize != null:
return initialize(_that.user);case _LocalImageChanged() when localImageChanged != null:
return localImageChanged(_that.imageFile);case _SaveProfile() when saveProfile != null:
return saveProfile(_that.name,_that.email,_that.phone);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( UserModel user)  initialize,required TResult Function( File imageFile)  localImageChanged,required TResult Function( String name,  String email,  String phone)  saveProfile,}) {final _that = this;
switch (_that) {
case _Initialize():
return initialize(_that.user);case _LocalImageChanged():
return localImageChanged(_that.imageFile);case _SaveProfile():
return saveProfile(_that.name,_that.email,_that.phone);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( UserModel user)?  initialize,TResult? Function( File imageFile)?  localImageChanged,TResult? Function( String name,  String email,  String phone)?  saveProfile,}) {final _that = this;
switch (_that) {
case _Initialize() when initialize != null:
return initialize(_that.user);case _LocalImageChanged() when localImageChanged != null:
return localImageChanged(_that.imageFile);case _SaveProfile() when saveProfile != null:
return saveProfile(_that.name,_that.email,_that.phone);case _:
  return null;

}
}

}

/// @nodoc


class _Initialize implements EditProfileEvent {
  const _Initialize({required this.user});
  

 final  UserModel user;

/// Create a copy of EditProfileEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InitializeCopyWith<_Initialize> get copyWith => __$InitializeCopyWithImpl<_Initialize>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Initialize&&(identical(other.user, user) || other.user == user));
}


@override
int get hashCode => Object.hash(runtimeType,user);

@override
String toString() {
  return 'EditProfileEvent.initialize(user: $user)';
}


}

/// @nodoc
abstract mixin class _$InitializeCopyWith<$Res> implements $EditProfileEventCopyWith<$Res> {
  factory _$InitializeCopyWith(_Initialize value, $Res Function(_Initialize) _then) = __$InitializeCopyWithImpl;
@useResult
$Res call({
 UserModel user
});




}
/// @nodoc
class __$InitializeCopyWithImpl<$Res>
    implements _$InitializeCopyWith<$Res> {
  __$InitializeCopyWithImpl(this._self, this._then);

  final _Initialize _self;
  final $Res Function(_Initialize) _then;

/// Create a copy of EditProfileEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? user = null,}) {
  return _then(_Initialize(
user: null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as UserModel,
  ));
}


}

/// @nodoc


class _LocalImageChanged implements EditProfileEvent {
  const _LocalImageChanged({required this.imageFile});
  

 final  File imageFile;

/// Create a copy of EditProfileEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LocalImageChangedCopyWith<_LocalImageChanged> get copyWith => __$LocalImageChangedCopyWithImpl<_LocalImageChanged>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LocalImageChanged&&(identical(other.imageFile, imageFile) || other.imageFile == imageFile));
}


@override
int get hashCode => Object.hash(runtimeType,imageFile);

@override
String toString() {
  return 'EditProfileEvent.localImageChanged(imageFile: $imageFile)';
}


}

/// @nodoc
abstract mixin class _$LocalImageChangedCopyWith<$Res> implements $EditProfileEventCopyWith<$Res> {
  factory _$LocalImageChangedCopyWith(_LocalImageChanged value, $Res Function(_LocalImageChanged) _then) = __$LocalImageChangedCopyWithImpl;
@useResult
$Res call({
 File imageFile
});




}
/// @nodoc
class __$LocalImageChangedCopyWithImpl<$Res>
    implements _$LocalImageChangedCopyWith<$Res> {
  __$LocalImageChangedCopyWithImpl(this._self, this._then);

  final _LocalImageChanged _self;
  final $Res Function(_LocalImageChanged) _then;

/// Create a copy of EditProfileEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? imageFile = null,}) {
  return _then(_LocalImageChanged(
imageFile: null == imageFile ? _self.imageFile : imageFile // ignore: cast_nullable_to_non_nullable
as File,
  ));
}


}

/// @nodoc


class _SaveProfile implements EditProfileEvent {
  const _SaveProfile({required this.name, required this.email, required this.phone});
  

 final  String name;
 final  String email;
 final  String phone;

/// Create a copy of EditProfileEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SaveProfileCopyWith<_SaveProfile> get copyWith => __$SaveProfileCopyWithImpl<_SaveProfile>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SaveProfile&&(identical(other.name, name) || other.name == name)&&(identical(other.email, email) || other.email == email)&&(identical(other.phone, phone) || other.phone == phone));
}


@override
int get hashCode => Object.hash(runtimeType,name,email,phone);

@override
String toString() {
  return 'EditProfileEvent.saveProfile(name: $name, email: $email, phone: $phone)';
}


}

/// @nodoc
abstract mixin class _$SaveProfileCopyWith<$Res> implements $EditProfileEventCopyWith<$Res> {
  factory _$SaveProfileCopyWith(_SaveProfile value, $Res Function(_SaveProfile) _then) = __$SaveProfileCopyWithImpl;
@useResult
$Res call({
 String name, String email, String phone
});




}
/// @nodoc
class __$SaveProfileCopyWithImpl<$Res>
    implements _$SaveProfileCopyWith<$Res> {
  __$SaveProfileCopyWithImpl(this._self, this._then);

  final _SaveProfile _self;
  final $Res Function(_SaveProfile) _then;

/// Create a copy of EditProfileEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? name = null,Object? email = null,Object? phone = null,}) {
  return _then(_SaveProfile(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$EditProfileState {

 UserModel? get user; File? get localImageFile; Status get status; String? get errorMessage;
/// Create a copy of EditProfileState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EditProfileStateCopyWith<EditProfileState> get copyWith => _$EditProfileStateCopyWithImpl<EditProfileState>(this as EditProfileState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EditProfileState&&(identical(other.user, user) || other.user == user)&&(identical(other.localImageFile, localImageFile) || other.localImageFile == localImageFile)&&(identical(other.status, status) || other.status == status)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,user,localImageFile,status,errorMessage);

@override
String toString() {
  return 'EditProfileState(user: $user, localImageFile: $localImageFile, status: $status, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $EditProfileStateCopyWith<$Res>  {
  factory $EditProfileStateCopyWith(EditProfileState value, $Res Function(EditProfileState) _then) = _$EditProfileStateCopyWithImpl;
@useResult
$Res call({
 UserModel? user, File? localImageFile, Status status, String? errorMessage
});




}
/// @nodoc
class _$EditProfileStateCopyWithImpl<$Res>
    implements $EditProfileStateCopyWith<$Res> {
  _$EditProfileStateCopyWithImpl(this._self, this._then);

  final EditProfileState _self;
  final $Res Function(EditProfileState) _then;

/// Create a copy of EditProfileState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? user = freezed,Object? localImageFile = freezed,Object? status = null,Object? errorMessage = freezed,}) {
  return _then(_self.copyWith(
user: freezed == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as UserModel?,localImageFile: freezed == localImageFile ? _self.localImageFile : localImageFile // ignore: cast_nullable_to_non_nullable
as File?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as Status,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [EditProfileState].
extension EditProfileStatePatterns on EditProfileState {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EditProfileState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EditProfileState() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EditProfileState value)  $default,){
final _that = this;
switch (_that) {
case _EditProfileState():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EditProfileState value)?  $default,){
final _that = this;
switch (_that) {
case _EditProfileState() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( UserModel? user,  File? localImageFile,  Status status,  String? errorMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EditProfileState() when $default != null:
return $default(_that.user,_that.localImageFile,_that.status,_that.errorMessage);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( UserModel? user,  File? localImageFile,  Status status,  String? errorMessage)  $default,) {final _that = this;
switch (_that) {
case _EditProfileState():
return $default(_that.user,_that.localImageFile,_that.status,_that.errorMessage);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( UserModel? user,  File? localImageFile,  Status status,  String? errorMessage)?  $default,) {final _that = this;
switch (_that) {
case _EditProfileState() when $default != null:
return $default(_that.user,_that.localImageFile,_that.status,_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc


class _EditProfileState implements EditProfileState {
  const _EditProfileState({this.user, this.localImageFile, this.status = Status.init, this.errorMessage});
  

@override final  UserModel? user;
@override final  File? localImageFile;
@override@JsonKey() final  Status status;
@override final  String? errorMessage;

/// Create a copy of EditProfileState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EditProfileStateCopyWith<_EditProfileState> get copyWith => __$EditProfileStateCopyWithImpl<_EditProfileState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EditProfileState&&(identical(other.user, user) || other.user == user)&&(identical(other.localImageFile, localImageFile) || other.localImageFile == localImageFile)&&(identical(other.status, status) || other.status == status)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,user,localImageFile,status,errorMessage);

@override
String toString() {
  return 'EditProfileState(user: $user, localImageFile: $localImageFile, status: $status, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class _$EditProfileStateCopyWith<$Res> implements $EditProfileStateCopyWith<$Res> {
  factory _$EditProfileStateCopyWith(_EditProfileState value, $Res Function(_EditProfileState) _then) = __$EditProfileStateCopyWithImpl;
@override @useResult
$Res call({
 UserModel? user, File? localImageFile, Status status, String? errorMessage
});




}
/// @nodoc
class __$EditProfileStateCopyWithImpl<$Res>
    implements _$EditProfileStateCopyWith<$Res> {
  __$EditProfileStateCopyWithImpl(this._self, this._then);

  final _EditProfileState _self;
  final $Res Function(_EditProfileState) _then;

/// Create a copy of EditProfileState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? user = freezed,Object? localImageFile = freezed,Object? status = null,Object? errorMessage = freezed,}) {
  return _then(_EditProfileState(
user: freezed == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as UserModel?,localImageFile: freezed == localImageFile ? _self.localImageFile : localImageFile // ignore: cast_nullable_to_non_nullable
as File?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as Status,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
