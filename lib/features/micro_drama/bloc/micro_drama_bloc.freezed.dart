// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'micro_drama_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MicroDramaEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MicroDramaEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'MicroDramaEvent()';
}


}

/// @nodoc
class $MicroDramaEventCopyWith<$Res>  {
$MicroDramaEventCopyWith(MicroDramaEvent _, $Res Function(MicroDramaEvent) __);
}


/// Adds pattern-matching-related methods to [MicroDramaEvent].
extension MicroDramaEventPatterns on MicroDramaEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _AllMicroDrama value)?  allMicroDrama,TResult Function( _DetailMicroDrama value)?  detailMicroDrama,TResult Function( _EpisodeDetail value)?  episodeDetail,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AllMicroDrama() when allMicroDrama != null:
return allMicroDrama(_that);case _DetailMicroDrama() when detailMicroDrama != null:
return detailMicroDrama(_that);case _EpisodeDetail() when episodeDetail != null:
return episodeDetail(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _AllMicroDrama value)  allMicroDrama,required TResult Function( _DetailMicroDrama value)  detailMicroDrama,required TResult Function( _EpisodeDetail value)  episodeDetail,}){
final _that = this;
switch (_that) {
case _AllMicroDrama():
return allMicroDrama(_that);case _DetailMicroDrama():
return detailMicroDrama(_that);case _EpisodeDetail():
return episodeDetail(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _AllMicroDrama value)?  allMicroDrama,TResult? Function( _DetailMicroDrama value)?  detailMicroDrama,TResult? Function( _EpisodeDetail value)?  episodeDetail,}){
final _that = this;
switch (_that) {
case _AllMicroDrama() when allMicroDrama != null:
return allMicroDrama(_that);case _DetailMicroDrama() when detailMicroDrama != null:
return detailMicroDrama(_that);case _EpisodeDetail() when episodeDetail != null:
return episodeDetail(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  allMicroDrama,TResult Function( String id)?  detailMicroDrama,TResult Function( String id)?  episodeDetail,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AllMicroDrama() when allMicroDrama != null:
return allMicroDrama();case _DetailMicroDrama() when detailMicroDrama != null:
return detailMicroDrama(_that.id);case _EpisodeDetail() when episodeDetail != null:
return episodeDetail(_that.id);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  allMicroDrama,required TResult Function( String id)  detailMicroDrama,required TResult Function( String id)  episodeDetail,}) {final _that = this;
switch (_that) {
case _AllMicroDrama():
return allMicroDrama();case _DetailMicroDrama():
return detailMicroDrama(_that.id);case _EpisodeDetail():
return episodeDetail(_that.id);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  allMicroDrama,TResult? Function( String id)?  detailMicroDrama,TResult? Function( String id)?  episodeDetail,}) {final _that = this;
switch (_that) {
case _AllMicroDrama() when allMicroDrama != null:
return allMicroDrama();case _DetailMicroDrama() when detailMicroDrama != null:
return detailMicroDrama(_that.id);case _EpisodeDetail() when episodeDetail != null:
return episodeDetail(_that.id);case _:
  return null;

}
}

}

/// @nodoc


class _AllMicroDrama implements MicroDramaEvent {
  const _AllMicroDrama();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AllMicroDrama);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'MicroDramaEvent.allMicroDrama()';
}


}




/// @nodoc


class _DetailMicroDrama implements MicroDramaEvent {
  const _DetailMicroDrama({required this.id});
  

 final  String id;

/// Create a copy of MicroDramaEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DetailMicroDramaCopyWith<_DetailMicroDrama> get copyWith => __$DetailMicroDramaCopyWithImpl<_DetailMicroDrama>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DetailMicroDrama&&(identical(other.id, id) || other.id == id));
}


@override
int get hashCode => Object.hash(runtimeType,id);

@override
String toString() {
  return 'MicroDramaEvent.detailMicroDrama(id: $id)';
}


}

/// @nodoc
abstract mixin class _$DetailMicroDramaCopyWith<$Res> implements $MicroDramaEventCopyWith<$Res> {
  factory _$DetailMicroDramaCopyWith(_DetailMicroDrama value, $Res Function(_DetailMicroDrama) _then) = __$DetailMicroDramaCopyWithImpl;
@useResult
$Res call({
 String id
});




}
/// @nodoc
class __$DetailMicroDramaCopyWithImpl<$Res>
    implements _$DetailMicroDramaCopyWith<$Res> {
  __$DetailMicroDramaCopyWithImpl(this._self, this._then);

  final _DetailMicroDrama _self;
  final $Res Function(_DetailMicroDrama) _then;

/// Create a copy of MicroDramaEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? id = null,}) {
  return _then(_DetailMicroDrama(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _EpisodeDetail implements MicroDramaEvent {
  const _EpisodeDetail({required this.id});
  

 final  String id;

/// Create a copy of MicroDramaEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EpisodeDetailCopyWith<_EpisodeDetail> get copyWith => __$EpisodeDetailCopyWithImpl<_EpisodeDetail>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EpisodeDetail&&(identical(other.id, id) || other.id == id));
}


@override
int get hashCode => Object.hash(runtimeType,id);

@override
String toString() {
  return 'MicroDramaEvent.episodeDetail(id: $id)';
}


}

/// @nodoc
abstract mixin class _$EpisodeDetailCopyWith<$Res> implements $MicroDramaEventCopyWith<$Res> {
  factory _$EpisodeDetailCopyWith(_EpisodeDetail value, $Res Function(_EpisodeDetail) _then) = __$EpisodeDetailCopyWithImpl;
@useResult
$Res call({
 String id
});




}
/// @nodoc
class __$EpisodeDetailCopyWithImpl<$Res>
    implements _$EpisodeDetailCopyWith<$Res> {
  __$EpisodeDetailCopyWithImpl(this._self, this._then);

  final _EpisodeDetail _self;
  final $Res Function(_EpisodeDetail) _then;

/// Create a copy of MicroDramaEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? id = null,}) {
  return _then(_EpisodeDetail(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$MicroDramaState {

 Status get allMicroDramaStatus; MicrodramasResponse? get allMicroDrama; MicrodramaDetailResponse? get dramaDetail; Status get detailDramaStatus; Status get episodeDetailStatus; EpisodesResponse? get episodeDetail;
/// Create a copy of MicroDramaState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MicroDramaStateCopyWith<MicroDramaState> get copyWith => _$MicroDramaStateCopyWithImpl<MicroDramaState>(this as MicroDramaState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MicroDramaState&&(identical(other.allMicroDramaStatus, allMicroDramaStatus) || other.allMicroDramaStatus == allMicroDramaStatus)&&(identical(other.allMicroDrama, allMicroDrama) || other.allMicroDrama == allMicroDrama)&&(identical(other.dramaDetail, dramaDetail) || other.dramaDetail == dramaDetail)&&(identical(other.detailDramaStatus, detailDramaStatus) || other.detailDramaStatus == detailDramaStatus)&&(identical(other.episodeDetailStatus, episodeDetailStatus) || other.episodeDetailStatus == episodeDetailStatus)&&(identical(other.episodeDetail, episodeDetail) || other.episodeDetail == episodeDetail));
}


@override
int get hashCode => Object.hash(runtimeType,allMicroDramaStatus,allMicroDrama,dramaDetail,detailDramaStatus,episodeDetailStatus,episodeDetail);

@override
String toString() {
  return 'MicroDramaState(allMicroDramaStatus: $allMicroDramaStatus, allMicroDrama: $allMicroDrama, dramaDetail: $dramaDetail, detailDramaStatus: $detailDramaStatus, episodeDetailStatus: $episodeDetailStatus, episodeDetail: $episodeDetail)';
}


}

/// @nodoc
abstract mixin class $MicroDramaStateCopyWith<$Res>  {
  factory $MicroDramaStateCopyWith(MicroDramaState value, $Res Function(MicroDramaState) _then) = _$MicroDramaStateCopyWithImpl;
@useResult
$Res call({
 Status allMicroDramaStatus, MicrodramasResponse? allMicroDrama, MicrodramaDetailResponse? dramaDetail, Status detailDramaStatus, Status episodeDetailStatus, EpisodesResponse? episodeDetail
});




}
/// @nodoc
class _$MicroDramaStateCopyWithImpl<$Res>
    implements $MicroDramaStateCopyWith<$Res> {
  _$MicroDramaStateCopyWithImpl(this._self, this._then);

  final MicroDramaState _self;
  final $Res Function(MicroDramaState) _then;

/// Create a copy of MicroDramaState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? allMicroDramaStatus = null,Object? allMicroDrama = freezed,Object? dramaDetail = freezed,Object? detailDramaStatus = null,Object? episodeDetailStatus = null,Object? episodeDetail = freezed,}) {
  return _then(_self.copyWith(
allMicroDramaStatus: null == allMicroDramaStatus ? _self.allMicroDramaStatus : allMicroDramaStatus // ignore: cast_nullable_to_non_nullable
as Status,allMicroDrama: freezed == allMicroDrama ? _self.allMicroDrama : allMicroDrama // ignore: cast_nullable_to_non_nullable
as MicrodramasResponse?,dramaDetail: freezed == dramaDetail ? _self.dramaDetail : dramaDetail // ignore: cast_nullable_to_non_nullable
as MicrodramaDetailResponse?,detailDramaStatus: null == detailDramaStatus ? _self.detailDramaStatus : detailDramaStatus // ignore: cast_nullable_to_non_nullable
as Status,episodeDetailStatus: null == episodeDetailStatus ? _self.episodeDetailStatus : episodeDetailStatus // ignore: cast_nullable_to_non_nullable
as Status,episodeDetail: freezed == episodeDetail ? _self.episodeDetail : episodeDetail // ignore: cast_nullable_to_non_nullable
as EpisodesResponse?,
  ));
}

}


/// Adds pattern-matching-related methods to [MicroDramaState].
extension MicroDramaStatePatterns on MicroDramaState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MicroDramaState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MicroDramaState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MicroDramaState value)  $default,){
final _that = this;
switch (_that) {
case _MicroDramaState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MicroDramaState value)?  $default,){
final _that = this;
switch (_that) {
case _MicroDramaState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Status allMicroDramaStatus,  MicrodramasResponse? allMicroDrama,  MicrodramaDetailResponse? dramaDetail,  Status detailDramaStatus,  Status episodeDetailStatus,  EpisodesResponse? episodeDetail)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MicroDramaState() when $default != null:
return $default(_that.allMicroDramaStatus,_that.allMicroDrama,_that.dramaDetail,_that.detailDramaStatus,_that.episodeDetailStatus,_that.episodeDetail);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Status allMicroDramaStatus,  MicrodramasResponse? allMicroDrama,  MicrodramaDetailResponse? dramaDetail,  Status detailDramaStatus,  Status episodeDetailStatus,  EpisodesResponse? episodeDetail)  $default,) {final _that = this;
switch (_that) {
case _MicroDramaState():
return $default(_that.allMicroDramaStatus,_that.allMicroDrama,_that.dramaDetail,_that.detailDramaStatus,_that.episodeDetailStatus,_that.episodeDetail);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Status allMicroDramaStatus,  MicrodramasResponse? allMicroDrama,  MicrodramaDetailResponse? dramaDetail,  Status detailDramaStatus,  Status episodeDetailStatus,  EpisodesResponse? episodeDetail)?  $default,) {final _that = this;
switch (_that) {
case _MicroDramaState() when $default != null:
return $default(_that.allMicroDramaStatus,_that.allMicroDrama,_that.dramaDetail,_that.detailDramaStatus,_that.episodeDetailStatus,_that.episodeDetail);case _:
  return null;

}
}

}

/// @nodoc


class _MicroDramaState implements MicroDramaState {
  const _MicroDramaState({this.allMicroDramaStatus = Status.init, this.allMicroDrama = null, this.dramaDetail = null, this.detailDramaStatus = Status.init, this.episodeDetailStatus = Status.init, this.episodeDetail = null});
  

@override@JsonKey() final  Status allMicroDramaStatus;
@override@JsonKey() final  MicrodramasResponse? allMicroDrama;
@override@JsonKey() final  MicrodramaDetailResponse? dramaDetail;
@override@JsonKey() final  Status detailDramaStatus;
@override@JsonKey() final  Status episodeDetailStatus;
@override@JsonKey() final  EpisodesResponse? episodeDetail;

/// Create a copy of MicroDramaState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MicroDramaStateCopyWith<_MicroDramaState> get copyWith => __$MicroDramaStateCopyWithImpl<_MicroDramaState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MicroDramaState&&(identical(other.allMicroDramaStatus, allMicroDramaStatus) || other.allMicroDramaStatus == allMicroDramaStatus)&&(identical(other.allMicroDrama, allMicroDrama) || other.allMicroDrama == allMicroDrama)&&(identical(other.dramaDetail, dramaDetail) || other.dramaDetail == dramaDetail)&&(identical(other.detailDramaStatus, detailDramaStatus) || other.detailDramaStatus == detailDramaStatus)&&(identical(other.episodeDetailStatus, episodeDetailStatus) || other.episodeDetailStatus == episodeDetailStatus)&&(identical(other.episodeDetail, episodeDetail) || other.episodeDetail == episodeDetail));
}


@override
int get hashCode => Object.hash(runtimeType,allMicroDramaStatus,allMicroDrama,dramaDetail,detailDramaStatus,episodeDetailStatus,episodeDetail);

@override
String toString() {
  return 'MicroDramaState(allMicroDramaStatus: $allMicroDramaStatus, allMicroDrama: $allMicroDrama, dramaDetail: $dramaDetail, detailDramaStatus: $detailDramaStatus, episodeDetailStatus: $episodeDetailStatus, episodeDetail: $episodeDetail)';
}


}

/// @nodoc
abstract mixin class _$MicroDramaStateCopyWith<$Res> implements $MicroDramaStateCopyWith<$Res> {
  factory _$MicroDramaStateCopyWith(_MicroDramaState value, $Res Function(_MicroDramaState) _then) = __$MicroDramaStateCopyWithImpl;
@override @useResult
$Res call({
 Status allMicroDramaStatus, MicrodramasResponse? allMicroDrama, MicrodramaDetailResponse? dramaDetail, Status detailDramaStatus, Status episodeDetailStatus, EpisodesResponse? episodeDetail
});




}
/// @nodoc
class __$MicroDramaStateCopyWithImpl<$Res>
    implements _$MicroDramaStateCopyWith<$Res> {
  __$MicroDramaStateCopyWithImpl(this._self, this._then);

  final _MicroDramaState _self;
  final $Res Function(_MicroDramaState) _then;

/// Create a copy of MicroDramaState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? allMicroDramaStatus = null,Object? allMicroDrama = freezed,Object? dramaDetail = freezed,Object? detailDramaStatus = null,Object? episodeDetailStatus = null,Object? episodeDetail = freezed,}) {
  return _then(_MicroDramaState(
allMicroDramaStatus: null == allMicroDramaStatus ? _self.allMicroDramaStatus : allMicroDramaStatus // ignore: cast_nullable_to_non_nullable
as Status,allMicroDrama: freezed == allMicroDrama ? _self.allMicroDrama : allMicroDrama // ignore: cast_nullable_to_non_nullable
as MicrodramasResponse?,dramaDetail: freezed == dramaDetail ? _self.dramaDetail : dramaDetail // ignore: cast_nullable_to_non_nullable
as MicrodramaDetailResponse?,detailDramaStatus: null == detailDramaStatus ? _self.detailDramaStatus : detailDramaStatus // ignore: cast_nullable_to_non_nullable
as Status,episodeDetailStatus: null == episodeDetailStatus ? _self.episodeDetailStatus : episodeDetailStatus // ignore: cast_nullable_to_non_nullable
as Status,episodeDetail: freezed == episodeDetail ? _self.episodeDetail : episodeDetail // ignore: cast_nullable_to_non_nullable
as EpisodesResponse?,
  ));
}


}

// dart format on
