String getChatId({required int uid, required int peeredUserId}) {
  return uid < peeredUserId ? '$uid-$peeredUserId' : '$peeredUserId-$uid';
}
