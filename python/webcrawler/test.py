#!/usr/bin/env python
# -*- coding: UTF-8 -*-

from selenium import webdriver
from selenium.webdriver.common.keys import Keys


driver = webdriver.Firefox()
driver.get('http://www.piaotian.com/')
assert "piaotian" in driver.title

elem = driver.find_element_by_name('searchkey')
elem.send_keys("混元剑帝")
elem.send_keys(Keys.RETURN)
