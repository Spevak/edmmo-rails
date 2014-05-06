//Definitions for the python builtin types item and inventory.

/**
 * @constructor
 * @param {string} itemType the name of the type of item (e.g. potato)
 * @param {number} itemId the id number of this particular item instance
 * @extends Sk.builtin.object
 */
Sk.builtin.item = function(itemType, itemId, attributes) {
    if (!(this instanceof Sk.builtin.item)) return new Sk.builtin.item(itemType, itemId, {});

    var attr;
    if (attributes === undefined) {
	attr = {};
    } else {
	attr = attributes;
    }

    this.v = {type: itemType, id: itemId, attributes: attr};

    this.__class__ = Sk.builtin.item;

    this["v"] = this.v;
    return this;
};

Sk.builtin.item.prototype.ob$type = Sk.builtin.type.makeIntoTypeObj('item', Sk.builtin.item);

Sk.builtin.item.tp$name = "item";
Sk.builtin.item.prototype['$r'] = function() {
    return new Sk.builtin.str("Item: <type = " + this.v['type'] + ", id = " + this.v['id'].toString() + ">");
}

Sk.builtin.item.prototype.tp$getattr = Sk.builtin.object.prototype.GenericGetAttr;
Sk.builtin.item.prototype.tp$hash = Sk.builtin.object.prototype.HashNotImplemented;

Sk.builtin.item.prototype['id'] = new Sk.builtin.func(function(self) {
    Sk.builtin.pyCheckArgs("id", arguments, 1, 1);
    return new Sk.builtin.nmber(self.v['id'], Sk.builtin.nmber.int$);
});

Sk.builtin.item.prototype['name'] = new Sk.builtin.func(function(self) {
    Sk.builtin.pyCheckArgs('name', arguments, 1, 1);
    return new Sk.builtin.str(self.v['type']);
});

Sk.builtin.item.prototype['useItem'] = new Sk.builtin.func(function(self) {
    Sk.builtin.pyCheckArgs('useItem', arguments, 1, 1);
    var id = new Sk.builtin.str(self.v['id'].toString());
    var args = new Sk.builtin.str("");
    Sk.builtin.useFunction(id, args);
    return Sk.builtin.none.none$;
});

goog.exportSymbol("Sk.builtin.item", Sk.builtin.item);


/**
 * @constructor
 */
Sk.builtin.inventory = function() {
    if (!(this instanceof Sk.builtin.inventory)) return new Sk.builtin.inventory();

    this.v = {}

    this.__class__ = Sk.builtin.inventory;

    this["v"] = this.v
    return this;
};

Sk.builtin.inventory.prototype.ob$type = Sk.builtin.type.makeIntoTypeObj('inventory', Sk.builtin.inventory);

Sk.builtin.inventory.tp$name = "inventory";
Sk.builtin.inventory.prototype['$r'] = function () {
    return new Sk.builtin.str("Inventory: ");
}

Sk.builtin.inventory.prototype.tp$getattr = Sk.builtin.object.prototype.GenericGetAttr;
Sk.builtin.inventory.prototype.tp$hash = Sk.builtin.object.prototype.HashNotImplemented;
Sk.builtin.inventory.inventory$ = new Sk.builtin.inventory();

goog.exportSymbol("Sk.builtin.inventory", Sk.builtin.inventory);
