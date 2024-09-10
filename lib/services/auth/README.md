# the point of this interface
# is to prevent the UI from seeing (e.g communicating with) the auth service
# so any implementation related to any authintication service will be in the interface itself
# and the service will provide us with any auth functionality
# such as: login - registration - user info - exceptions - ..
