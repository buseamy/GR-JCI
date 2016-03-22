USE gr_jci;

/* MySql event to expire unverified email address changes */
DROP EVENT IF EXISTS evJobUpdateExpireUsersEmailAddressChange;
CREATE EVENT evJobUpdateExpireUsersEmailAddressChange
ON SCHEDULE EVERY 1 DAY
STARTS '2016-05-30 23:59:00'
ON COMPLETION NOT PRESERVE ENABLE
DO Call spJobUpdateExpireUsersEmailAddressChange();