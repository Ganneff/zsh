# -*- mode: sh;-*-

(( ${+http_proxy} )) || export http_proxy='http://fw003:8080/'
(( ${+ftp_proxy} )) || export ftp_proxy='http://fw003:8080/'

