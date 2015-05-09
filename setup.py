from setuptools import setup


setup(
  name='voting',
  version='0.1',
  description='voting',
  package_dir={'':'voting'},
  include_package_data=True,
  packages=['voting', 'core'],
  scripts=['voting/manage.py'],
)
