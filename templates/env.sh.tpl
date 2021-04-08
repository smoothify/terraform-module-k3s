#!/bin/sh
%{ for key, value in env ~}
export ${key}=${value}
%{ endfor ~}
