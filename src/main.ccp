#include <Geode/Geode.hpp>
#include <Geode/modify/CCDirector.hpp>

using namespace geode::prelude;

static double targetInterval() {
	int fps = Mod::get()->getSettingValue<int64_t>("fps");
	if (fps < 1) fps = 1;
	return 1.0 / static_cast<double>(fps);
}

// Whenever the game tries to set its frame interval, use ours instead.
class $modify(FPSDirector, CCDirector) {
	void setAnimationInterval(double interval) {
		CCDirector::setAnimationInterval(targetInterval());
	}
};

// Apply immediately on load and whenever the setting changes.
$on_mod(Loaded) {
	CCDirector::get()->setAnimationInterval(targetInterval());

	listenForSettingChanges<int64_t>("fps", [](int64_t) {
		CCDirector::get()->setAnimationInterval(targetInterval());
	
});
}
